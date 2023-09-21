import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_chi_tiet_booking.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class BookingSuccess extends StatefulWidget {
  final details;
  const BookingSuccess({super.key, required this.details});

  @override
  State<BookingSuccess> createState() => _BookingSuccessState();
}

double circleSize = 140;
double iconSize = 108;

class _BookingSuccessState extends State<BookingSuccess>
    with TickerProviderStateMixin {

  LocalStorage storageAuth = LocalStorage("auth");
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

  String htlm =
      "<p>Nếu muốn thay đổi lịch hẹn bạn vui lòng gọi đến Hotline <a href='tel:1900123456'>1900123456</a> <strong>trước 1h</strong> với lịch đã hẹn trước đó</p>";

  @override
  Widget build(BuildContext context) {
    var details = widget.details;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              leadingWidth: 45,
              centerTitle: true,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                            ],
                          ),
                        ),
                        Wrap(
                          runSpacing: 15,
                          children: [
                              GestureDetector(
                                  child: Container(
                                    width: MediaQuery.of(
                                        context)
                                        .size
                                        .width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors
                                                .grey),
                                        borderRadius:
                                        const BorderRadius
                                            .all(
                                            Radius.circular(
                                                15))),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        const Text(
                                            "Xem chi tiết",
                                            style:
                                            TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight
                                                  .w400,
                                            )),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Image.asset(
                                          "assets/images/calendar-black.png",
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit
                                              .contain,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder:
                                                (context) =>
                                            const BookingHistory()));
                                    showModalBottomSheet<
                                        void>(
                                        backgroundColor:
                                        Colors.white,
                                        clipBehavior: Clip
                                            .antiAliasWithSaveLayer,
                                        context: context,
                                        isScrollControlled:
                                        true,
                                        builder:
                                            (BuildContext
                                        context) {
                                          return Container(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(
                                                      context)
                                                      .viewInsets
                                                      .bottom),
                                              height: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.95,
                                              child:
                                              ModalChiTietBooking(
                                                details:
                                               details,
                                              ));
                                        });
                                  }),
                            GestureDetector(
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                                        fit: BoxFit.contain,
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
