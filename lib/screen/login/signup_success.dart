import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';

class SignUpSuccess extends StatefulWidget {
  const SignUpSuccess({super.key});

  @override
  State<SignUpSuccess> createState() => _SignUpSuccessState();
}

double circleSize = 140;
double iconSize = 108;

class _SignUpSuccessState extends State<SignUpSuccess>
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
    void save() {
      setState(() {});
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 5,
            // ),
            appBar: AppBar(
                bottomOpacity: 0.0,
                elevation: 0.0,
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: const Text("Thông báo",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black))),
            drawer: const MyLeftMenu(),
            body: Container(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                                                width: 3, color: Colors.green)),
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
                                  "Đăng ký tài khoản!",
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
                                "Bạn đã đăng ký tài thành công",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Đăng nhập",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Image.asset(
                                        "assets/images/icon/profile-black.png",
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "home");
                                  showModalBottomSheet<void>(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15)),
                                      ),
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.9,
                                          child: ModalPassExist(
                                            save: save,
                                          ),
                                        );
                                      });
                                }),
                            GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Về trang chủ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Image.asset(
                                        "assets/images/icon/home-red.png",
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "home");
                                }),
                          ],
                        )
                      ],
                    )))));
  }
}
