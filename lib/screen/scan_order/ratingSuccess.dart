import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:upgrader/upgrader.dart';

class RatingSuccess extends StatefulWidget {
  const RatingSuccess({super.key});

  @override
  State<RatingSuccess> createState() => _RatingSuccessState();
}

double circleSize = 140;
double iconSize = 108;

class _RatingSuccessState extends State<RatingSuccess>
    with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(
      duration: const Duration(milliseconds: 800), vsync: this);
  late Animation<double> scaleAnimation =
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(
      duration: const Duration(milliseconds: 600), vsync: this);
  late Animation<double> checkAnimation =
      CurvedAnimation(parent: checkController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  // _makingPhoneCall() async {
  //   var url = Uri.parse("tel:9776765434");
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(
              active: -1,
            ),
            appBar: AppBar(
              leadingWidth: 45,
              centerTitle: true,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.west,
                      size: 16,
                      color: Colors.black,
                    ),
                  )),
              title: const Text("Thông báo",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Center(
                                    child: Stack(
                                      children: [
                                        ScaleTransition(
                                          scale: scaleAnimation,
                                          child: Container(
                                            height: circleSize,
                                            width: circleSize,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width)),
                                                border: Border.all(
                                                    width: 3,
                                                    color: Colors.green)),
                                          ),
                                        ),
                                        SizeTransition(
                                          sizeFactor: checkAnimation,
                                          axis: Axis.horizontal,
                                          axisAlignment: -1,
                                          child: Container(
                                            height: circleSize,
                                            width: circleSize,
                                            alignment: Alignment.center,
                                            child: Icon(Icons.check,
                                                color: Colors.green,
                                                size: iconSize),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "Gửi đáng giá thành công",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    "Cảm ơn quý khách đã đóng góp ý kiến!!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: mainColor.withOpacity(0.3),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Về trang chủ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Image.asset(
                                        "assets/images/icon/home.png",
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "home");
                                }),
                          ],
                        ))))));
  }
}
