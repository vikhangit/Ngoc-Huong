import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/firebase_options.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/account/information/information.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/cart/cart.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/notifications/notification.dart';
import 'package:ngoc_huong/screen/member/thanh_vien.dart';
import 'package:ngoc_huong/screen/news/tin_tuc.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // to initialize the notificationservice.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Upgrader.clearSavedSettings();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// // await setupFlutterNotifications();
// // showNotification(message);
//   print('${message.notification!.title}');
//   print('${message.notification!.body}');
//   print('${message.data}');
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

mixin AppLocale {
  static const String title = 'title';

  static const Map<String, dynamic> EN = {};
  static const Map<String, dynamic> VI = {};
}

class _MyAppState extends State<MyApp> {
  final LocalStorage storageCustomer = LocalStorage('customer_token');
  final CustomThemeData _customThemeData = CustomThemeData();
  final FlutterLocalization localization = FlutterLocalization.instance;
  final LocalStorage localStorageSlash = LocalStorage("slash");
  Future<void> launchInBrowser(String link) async {
    Uri url = Uri.parse(link);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    localization.init(
      mapLocales: [
        const MapLocale('vi', AppLocale.VI),
        const MapLocale('en', AppLocale.EN),
      ],
      initLanguageCode: 'vi',
    );
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      routes: {
        'start': (context) => const StartScreen(),
        'home': (context) => const HomeScreen(),
        'cart': (context) => const CartScreen(),
        'account': (context) => const AccountScreen(),
        "notifications": (context) => const NotificationScreen(),
        "tin_tuc": (context) => const TinTucScreen(),
        "hangthanhvien": (context) => const ThanhVienScreen(),
        "booking": (context) => const BookingServices(),
        "informationAccount": (context) => const InfomationAccount()
      },
      theme: _customThemeData.themeData,
      home: localStorageSlash.getItem("slash") == null
          ? const StartScreen()
          : storageCustomer.getItem("customer_token") != null
              ? const HomeScreen()
              : const LoginScreen(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}
