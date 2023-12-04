import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/choose_brand/chooseBrand.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
// import 'package:localstorage/localstorage.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

int activeDot = 0;
List list = [
  "",
  "",
  "",
];

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
  final LocalStorage storageCustomer = LocalStorage('customer_token');
  final LocalStorage storageBrand = LocalStorage('branch');
  final LocalStorage localStorageCustomerCart = LocalStorage("customer_cart");
  final LocalStorage localStorageStart = LocalStorage("start");
  final LocalStorage localStorageSlash = LocalStorage("slash");
  CarouselController buttonCarouselController = CarouselController();
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
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
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: mainColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              storageCustomer.getItem("customer_token") != null
                                  ? const HomeScreen()
                                  : const LoginScreen()));
                  localStorageSlash.setItem("slash", "true");
                  localStorageStart.setItem("start", "start");
                },
                child: Text(
                  "Bỏ qua",
                  style: TextStyle(color: mainColor, fontSize: 12),
                ),
              ),
            ),
            Container(
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                    onPressed: () {
                      if (activeDot == 4) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    storageCustomer.getItem("customer_token") !=
                                            null
                                        ? const HomeScreen()
                                        : const LoginScreen()));
                        localStorageSlash.setItem("slash", "true");
                        localStorageStart.setItem("start", "start");
                      } else {
                        buttonCarouselController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear);
                      }
                    },
                    child: Text(
                      activeDot == 4 ? "Bắt đầu" : "Tiếp tục",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )))
          ],
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: CarouselSlider(
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height,
                      // aspectRatio: 2.0,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeDot = index;
                        });
                      },
                    ),
                    items: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Chào mừng bạn đến với hệ thống thẩm mỹ Ngọc Hường",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            "assets/images/logo.png",
                            width: 100,
                            height: 100,
                          ),
                          // Stack(
                          //   children: [
                          //     const SizedBox(
                          //       width: 110,
                          //       height: 110,
                          //       child: LoadingIndicator(
                          //         colors: kDefaultRainbowColors,
                          //         indicatorType: Indicator.ballRotateChase,
                          //         strokeWidth: 3,
                          //         // pathBackgroundColor: Colors.black45,
                          //       ),
                          //     ),
                          //     Positioned.fill(
                          //         // top: 0,
                          //         //   left: 0,
                          //         child: Container(
                          //       alignment: Alignment.center,
                          //       child: Image.asset(
                          //         "assets/images/logo.png",
                          //         width: 60,
                          //         height: 60,
                          //       ),
                          //     ))
                          //   ],
                          // )
                        ],
                      ),
                      Image.asset(
                        "assets/images/start/1.jpg",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.fitHeight,
                      ),
                      Image.asset(
                        "assets/images/start/2.jpg",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.fitHeight,
                      ),
                      Image.asset(
                        "assets/images/start/3.jpg",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.fitHeight,
                      ),
                      Image.asset(
                        "assets/images/start/4.jpg",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.fitHeight,
                      )
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                  child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 15),
                child: DotsIndicator(
                  dotsCount: 5,
                  position: activeDot,
                  decorator: DotsDecorator(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      color: Colors.black26,
                      activeColor: mainColor,
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      spacing: const EdgeInsets.all(1.5)),
                ),
              ))
            ],
          )),
    ));
  }
}
