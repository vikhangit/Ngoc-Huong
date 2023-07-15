import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/booking_success.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class ConfirmBooking extends StatefulWidget {
  final String serviceName;
  final String chinhanhName;
  final String maKho;
  final String diaChiCuThe;
  final String time;
  final String day;
  final String month;
  final String year;
  const ConfirmBooking(
      {super.key,
      required this.serviceName,
      required this.chinhanhName,
      required this.maKho,
      required this.diaChiCuThe,
      required this.time,
      required this.day,
      required this.month,
      required this.year});

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

String ten_kh = "";
String tokenfirebase = "";

class _ConfirmBookingState extends State<ConfirmBooking> {
  NotificationService notificationService = NotificationService();
  LocalStorage storage = LocalStorage('auth');
  LocalStorage storageTolen = LocalStorage('token');
  @override
  void initState() {
    notificationService.requestNotificationPermission();
    notificationService.setupFlutterNotifications();
    notificationService.setupInteractMessage(context);
    // notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value) {
      print("Token: $value");
      setState(() {
        tokenfirebase = value;
      });
    });

    getProfile(storage.getItem("phone"))
        .then((value) => setState(() => ten_kh = value[0]["ma_kh"]));
    super.initState();
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    tz.initializeTimeZones();
    int hours = DateTime.parse(
            "${widget.year}-${widget.month}-${widget.day}T${widget.time}:00.534Z")
        .hour;
    late tz.TZDateTime now =
        tz.TZDateTime.now(tz.getLocation("Asia/Ho_Chi_Minh"));
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.getLocation("Asia/Ho_Chi_Minh"),
      int.parse(widget.year),
      int.parse(widget.month),
      int.parse(widget.day),
      hours - 1,
      30,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  void sendNotifications() {
    notificationService.firebaseInit(context, _nextInstanceOfTenAM());
    notificationService.getDeviceToken().then((value) async {
      var data = {
        "to": value.toString(),
        "priority": "high",
        "notification": {
          "title": "Thông báo lịch hẹn",
          "body":
              "Hôm nay bạn có lịch hẹn ${widget.serviceName} lúc ${widget.time} tại Ngọc Hường",
          "click_action": "TOP_STORY_ACTIVITY",
        },
        "data": {
          "type": "booking",
          "id": "1234",
          "isScheduled": "true",
          "scheduledTime": "2023-07-05 15:35:00"
        }
      };
      final dio = Dio();
      await dio.post('https://fcm.googleapis.com/fcm/send',
          data: data,
          options: Options(headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization":
                "key=AAAAVSpdxKI:APA91bFafJEmRCNIB0GLv-vEnBeOIsF2nICn0SC3Gz27T9N3lfuojy0F25p_JmB8Zl03NalDj4DgSUY0JaVbD70WICm0cSb6L7HY0fcIDfU92KjT2JdgrM_AEbnOyLKAD293QmK1li-0"
          }));
    });
  }

  void addBooking() {
    Map data = {
      "ma_kh": ten_kh,
      "ten_vt": widget.serviceName,
      "time_book": widget.time,
      "date_book":
          "${widget.year}-${widget.month}-${widget.day}T${widget.time}:32.534Z",
      "ngay": int.parse(widget.day),
      "thang": int.parse(widget.month),
      "nam": int.parse(widget.year),
      "chi_nhanh": widget.maKho,
      "trang_thai": 1,
      "dien_giai": "Đang chờ",
    };

    postBooking(data);
    sendNotifications();
  }

  @override
  Widget build(BuildContext context) {
    String serviceName = widget.serviceName;
    String chinhanhName = widget.chinhanhName;
    String diaChiCuThe = widget.diaChiCuThe;
    String time = widget.time;
    String date = "${widget.day}/${widget.month}/${widget.year}";
    void onLoading() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        addBooking();
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BookingSuccess())); //pop dialog
      });
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
                leadingWidth: 40,
                backgroundColor: Colors.white,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.west,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
                title: const Text("Kiểm tra thông tin",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black))),
            drawer: const MyLeftMenu(),
            body: Column(
                // reverse: true,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        const Text(
                          "Xác nhận thông tin",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Thông tin khách hàng",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(children: [
                                    Image.asset(
                                      "assets/images/icon/profile-red.png",
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    FutureBuilder(
                                      future:
                                          getProfile(storage.getItem("phone")),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data![0]["ten_kh"]}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          );
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    )
                                  ]),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(children: [
                                    Image.asset(
                                      "assets/images/call-solid-red.png",
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    FutureBuilder(
                                      future:
                                          getProfile(storage.getItem("phone")),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data![0]["of_user"]}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          );
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    )
                                  ]),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Chi nhánh",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/images/location-solid-red.png",
                                          width: 22,
                                          height: 22,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Chi nhánh $chinhanhName",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "$diaChiCuThe, $chinhanhName",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        ))
                                      ]),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Thời gian",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(children: [
                                    Image.asset(
                                      "assets/images/time-solid-red.png",
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "$time $date",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Dịch vụ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(children: [
                                    Image.asset(
                                      "assets/images/note-solid-red.png",
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Text(
                                      serviceName.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    )),
                                  ]),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                            // if (widget.dienGiai.isNotEmpty)
                            //   Container(
                            //     padding: const EdgeInsets.all(16),
                            //     margin: const EdgeInsets.only(top: 20),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: const BorderRadius.all(
                            //           Radius.circular(10)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.5),
                            //           spreadRadius: 1,
                            //           blurRadius: 8,
                            //           offset: const Offset(
                            //               4, 4), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         const Text(
                            //           "Ghi chú",
                            //           style: TextStyle(
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w400),
                            //         ),
                            //         const SizedBox(
                            //           height: 15,
                            //         ),
                            //         Row(children: [
                            //           Image.asset(
                            //             "assets/images/note-solid-red.png",
                            //             width: 22,
                            //             height: 22,
                            //             fit: BoxFit.contain,
                            //           ),
                            //           const SizedBox(
                            //             width: 8,
                            //           ),
                            //           Expanded(
                            //               child: Text(
                            //             widget.dienGiai.toString(),
                            //             style: const TextStyle(
                            //                 fontSize: 14,
                            //                 color: Colors.black,
                            //                 fontWeight: FontWeight.w300),
                            //           )),
                            //         ]),
                            //         const SizedBox(
                            //           height: 6,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        left: 15,
                        right: 15),
                    child: TextButton(
                        onPressed: () {
                          onLoading();
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20))),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            const Expanded(
                              flex: 8,
                              child: Center(
                                child: Text(
                                  "Xác nhận",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/calendar-white.png",
                                width: 25,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        )),
                  )
                ])));
  }
}
