import 'package:flutter/material.dart';

class TuVanSuccess extends StatefulWidget {
  const TuVanSuccess({super.key});

  @override
  State<TuVanSuccess> createState() => _TuVanSuccessState();
}

double circleSize = 140;
double iconSize = 108;

class _TuVanSuccessState extends State<TuVanSuccess>
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
                                  "Bạn đã gửi tư vấn thành công!",
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
                                "Cảm ơn bạn đã quan tâm đến dịch vụ của Ngọc Hường. Bộ phận chăm sóc khách hàng Ngọc Hường sẽ liên hệ bạn sớm nhất.",
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Về trang chủ",
                                    style: TextStyle(
                                        fontSize: 15,
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
                    )))));
  }
}
