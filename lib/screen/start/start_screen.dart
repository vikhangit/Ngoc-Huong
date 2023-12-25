import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/choose_brand/chooseBrand.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
import 'package:video_player/video_player.dart';
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
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset("assets/intro/intro.MP4");
    videoController.addListener(() {
      setState(() {});
    });
    videoController.setLooping(true);
    videoController.initialize().then((_) => setState(() {}));
    videoController.play();
    notificationService.requestNotificationPermission();
    Future.delayed(const Duration(milliseconds: 6000), () {
      videoController.pause();
      if (storageCustomer.getItem("customer_token") != null) {
        localStorageStart.deleteItem("start");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
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
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: videoController.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(videoController),
                    ],
                  ),
                ),
              ),
            )));
  }
}
