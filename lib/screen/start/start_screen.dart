import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/choose_brand/chooseBrand.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
// import 'package:localstorage/localstorage.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

String provinceId = "";
String valueSearch = "";

class _StartScreenState extends State<StartScreen> {
  NotificationService notificationService = NotificationService();
  final LocalStorage storage = LocalStorage('auth');
  LocalStorage storageCN = LocalStorage('chi_nhanh');
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    controller = TextEditingController(text: valueSearch);
    Future.delayed(const Duration(seconds: 3), () {
      if (storageCN.getItem("chi_nhanh") != null) {
        Navigator.pushNamed(context, "home");
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChooseBrandScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chào mừng bạn đến với Ngọc Hường",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    ));
  }
}
