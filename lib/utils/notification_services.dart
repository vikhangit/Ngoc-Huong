import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/account/buy_history/buy_history.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:timezone/timezone.dart';

@pragma('vm:entry-point')
class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  bool isFlutterLocalNotificationsInitialized = false;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      AppSettings.openNotificationSettings();
      print('User declined or has not accepted permission');
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(
      RemoteMessage message, TZDateTime scheduledDate) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notification.hashCode,
          notification.title,
          notification.body,
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id.toString(),
              channel.name.toString(),
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    }
  }

  void firebaseInit(BuildContext context, TZDateTime scheduledDate) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data["id"]);
        print(message.data["type"]);
      }
      setupFlutterNotifications();
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message, scheduledDate).then((value) {
          LocalStorage storageAuth = LocalStorage("auth");
          Map data = {
            "title": message.notification?.title ?? "",
            "email_receiver": storageAuth.getItem("phone"),
            "exfields": {
              "content": message.notification?.body ?? "",
              "id_app": idApp
            }
          };
          postNotifications(data);
        });
      } else {
        showNotification(message, scheduledDate);
      }
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("Refresh...");
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initMessage != null) {
      handleMessage(context, initMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const BuyHistory()));
  }
}
