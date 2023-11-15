import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/choose_brand/chooseBrand.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
// import 'package:localstorage/localstorage.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

const List<Color> kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class _StartScreenState extends State<StartScreen> {
  NotificationService notificationService = NotificationService();
  final LocalStorage storageCustomer = LocalStorage('customer_token');
  final LocalStorage storageBrand = LocalStorage('branch');
  final LocalStorage localStorageCustomerCart = LocalStorage("customer_cart");
  final LocalStorage localStorageStart = LocalStorage("start");
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    Future.delayed(const Duration(seconds: 1), () {
      if (storageCustomer.getItem("customer_token") != null) {
        if (storageBrand.getItem("branch") == null) {
          localStorageStart.deleteItem("start");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ChooseBrandScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } else {
        localStorageStart.setItem("start", "start");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
    if (FocusManager.instance.primaryFocus != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chào mừng bạn đến với hệ thống thẩm mỹ Ngọc Hường",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                const SizedBox(
                  width: 110,
                  height: 110,
                  child: LoadingIndicator(
                    colors: kDefaultRainbowColors,
                    indicatorType: Indicator.ballRotateChase,
                    strokeWidth: 3,
                    // pathBackgroundColor: Colors.black45,
                  ),
                ),
                Positioned.fill(
                    // top: 0,
                    //   left: 0,
                    child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 60,
                    height: 60,
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
