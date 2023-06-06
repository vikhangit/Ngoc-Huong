import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingSuccess extends StatefulWidget {
  const BookingSuccess({super.key});

  @override
  State<BookingSuccess> createState() => _BookingSuccessState();
}

double circleSize = 140;
double iconSize = 108;

class _BookingSuccessState extends State<BookingSuccess>
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

  _makingPhoneCall() async {
    var url = Uri.parse("tel:9776765434");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                title: const Text("Kiểm tra thông tin",
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 175,
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
                                  "Bạn đã đặt lịch hẹn thành công!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/info-red.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Lưu ý:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Wrap(
                                    children: [
                                      const Text(
                                        "Nếu muốn thay đổi lịch hẹn bạn vui lòng gọi đến ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => _makingPhoneCall(),
                                        child: Text(
                                          "Hotline 1900 7067 ",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "trước 1h ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const Text(
                                        "với lịch đã hẹn trước đó",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          spacing: 15,
                          children: [
                            InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      22.5,
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
                                      Image.asset(
                                        "assets/images/icon/home-red.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fill,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Về trang chủ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "home");
                                }),
                            InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      22.5,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Tiếp tục đặt lịch",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Image.asset(
                                        "assets/images/calendar-white.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, "booking");
                                }),
                          ],
                        )
                      ],
                    )))));
  }
}
