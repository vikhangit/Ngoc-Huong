import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/booking_success.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_dia_chi.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class BookingServices extends StatefulWidget {
  final Map? dichvudachon;
  const BookingServices({super.key, this.dichvudachon});

  @override
  State<BookingServices> createState() => _BookingServicesState();
}

bool showService = false;
bool showDay = false;
bool showTime = false;
List<DateTime?> _singleDatePickerValueWithDefaultValue = [
  DateTime.now(),
];
List<String> weekDaysName = [
  'CN',
  'Thứ 2',
  'Thứ 3',
  'Thứ 4',
  'Thứ 5',
  'Thứ 6',
  'Thứ 7'
];
String tenkh = "";
String tokenfirebase = "";
String activeTime = "";
Map activeService = {};
List chooseService = [
  {
    "icon": "assets/images/Home/Services/phun-xam.png",
    "title": "Dịch vụ phun xăm",
    "show": true,
    "child": [
      {
        "title": "Phun xăm mày",
        "category": "647569c2706fa019e6720bd4",
        "show_category": true
      },
      {
        "title": "Phun mí mắt",
        "category": "647569cb706fa019e6720bee",
        "show_category": true
      },
      {
        "title": "Phun xăm môi",
        "category": "647569d6706fa019e6720c08",
        "show_category": true
      },
      {
        "title": "Xóa, sửa lại",
        "category": "64756a1c706fa019e6720c22",
        "show_category": true
      }
    ]
  },
  {
    "icon": "assets/images/Home/Services/lam-dep-da.png",
    "title": "Dịch vụ làm đẹp da",
    "show": true,
    "id": "64756979706fa019e6720b5d"
  },
  {
    "icon": "assets/images/Home/Services/spa.png",
    "title": "Dịch vụ spa",
    "show": true,
    "child": [
      {
        "title": "Tắm trắng",
        "category": "64756b65706fa019e6720d91",
        "show_category": true
      },
      {
        "title": "Triệt lông",
        "category": "64756b31706fa019e6720d5d",
        "show_category": true
      },
      {
        "title": "Giảm béo",
        "category": "64756b56706fa019e6720d77",
        "show_category": true
      }
    ]
  }
];

class _BookingServicesState extends State<BookingServices>
    with TickerProviderStateMixin {
  NotificationService notificationService = NotificationService();
  late AnimationController _animationController;
  late AnimationController _animationController2;
  late AnimationController _animationController3;
  LocalStorage storageAuth = LocalStorage("auth");
  LocalStorage storageCN = LocalStorage('chi_nhanh');

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        upperBound: 0.5);
    _animationController2 = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        upperBound: 0.5);
    _animationController3 = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        upperBound: 0.5);
    _animationController.reverse();
    _animationController2.reverse();
    _animationController3.reverse();
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
    setState(() {
      if (widget.dichvudachon != null) {
        activeService = widget.dichvudachon!;
        showService = true;
      } else {
        activeService = {};
      }
      activeTime = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    _animationController3.dispose();
    activeTime = "";
    activeService = {};
    super.dispose();
  }

  void chooseTime(String time) {
    setState(() {
      activeTime = time;
    });
  }

  void showServiceLevel1(int index) {
    for (var i = 0; i < chooseService.length; i++) {
      if (index == i) {
        setState(() {
          chooseService[i]["show"] = !chooseService[i]["show"];
        });
      }
    }
  }

  void showServiceLevel2(int index, int index2) {
    for (var i = 0; i < chooseService.length; i++) {
      if (chooseService[i]["child"] != null) {
        for (var j = 0; j < chooseService[i]["child"].length; j++) {
          if (index == i && index2 == j) {
            setState(() {
              chooseService[i]["child"][j]["show_category"] =
                  !chooseService[i]["child"][j]["show_category"];
            });
          }
        }
      }
    }
  }

  void saveCN() {
    setState(() {});
  }

  void chooseActiveService(Map item) {
    setState(() {
      activeService = item;
    });
  }

  void showAlertDialog(BuildContext context, String err) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.pop(context, 'OK'),
    );
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return SizedBox(
            // height: 30,
            width: MediaQuery.of(context).size.width,
            child: Text(
              style: const TextStyle(height: 1.6),
              err,
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String activeDay = DateFormat("dd").format(
        DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
    String activeMonth = DateFormat("MM").format(
        DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
    String activeYear = DateFormat("yyyy").format(
        DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
    Map chiNhanh = jsonDecode(storageCN.getItem("chi_nhanh"));
    tz.TZDateTime nextInstanceOfTenAM() {
      tz.initializeTimeZones();
      int hours = DateTime.parse(
              "$activeYear-$activeMonth-${activeDay}T$activeTime:00.000Z")
          .hour;
      late tz.TZDateTime now =
          tz.TZDateTime.now(tz.getLocation("Asia/Ho_Chi_Minh"));
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.getLocation("Asia/Ho_Chi_Minh"),
        int.parse(activeYear),
        int.parse(activeMonth),
        int.parse(activeDay),
        hours - 1,
        30,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      return scheduledDate;
    }

    void sendNotifications() {
      notificationService.firebaseInit(context, nextInstanceOfTenAM());
      notificationService.getDeviceToken().then((value) async {
        var data = {
          "to": value.toString(),
          "priority": "high",
          "notification": {
            "title": "Thông báo lịch hẹn",
            "body":
                "Hôm nay bạn có lịch hẹn ${activeService["ten_vt"]} lúc $activeTime tại Ngọc Hường",
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

    void addBooking(String makh) {
      Map data = {
        "ma_kh": makh,
        "ten_vt": activeService["ten_vt"],
        "time_book": activeTime,
        "date_book":
            "$activeYear-$activeMonth-${activeDay}T$activeTime:00.000Z",
        "ngay": int.parse(activeDay),
        "thang": int.parse(activeMonth),
        "nam": int.parse(activeYear),
        "chi_nhanh": chiNhanh["ma_kho"],
        "trang_thai": 1,
        "dien_giai": "Đang chờ",
      };
      postBooking(data);
      sendNotifications();
    }

    void onLoading(String maKh) {
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
        addBooking(maKh);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BookingSuccess())); //pop dialog
      });
    }

    void showModalInfo() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(
              builder: (context) {
                return SizedBox(
                    // height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info,
                          size: 70,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Xác nhận đặt lịch",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Bạn có chắc chắn đặt lịch này không?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w300),
                        )
                      ],
                    ));
              },
            ),
            actionsPadding:
                const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: getProfile(storageAuth.getItem("phone")),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TextButton(
                        onPressed: () {
                          onLoading(snapshot.data![0]["ma_kh"]);
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 15)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary)),
                        child: const Text(
                          "Đồng ý",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 15)),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(color: Colors.grey, width: 1))),
                  ),
                  child: const Text("Hủy bỏ"),
                ),
              )
            ],
          );
        },
      );
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                bottomOpacity: 0.0,
                elevation: 0.0,
                leadingWidth: 40,
                backgroundColor: Colors.white,
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("Đặt lịch tại",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.black)),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0),
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  height:
                                      MediaQuery.of(context).size.height * .96,
                                  child: ModalDiaChi(
                                    saveCN: saveCN,
                                  ),
                                );
                              });
                        },
                        child: SizedBox(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.fmd_good_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              chiNhanh.isNotEmpty
                                  ? FutureBuilder(
                                      future: callChiNhanhApiByCN(
                                          chiNhanh["ma_kho"]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                              snapshot.data![0]["ten_kho"],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black));
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    )
                                  : const Text("Đặt lịch",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ))
                  ],
                )),
            drawer: const MyLeftMenu(),
            body: Column(
                // reverse: true,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Tên",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            FutureBuilder(
                              future: callProfile(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: "${snapshot.data["name"]}"),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      filled: true, //<-- SEE HERE
                                      fillColor: Colors.grey[200],
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary), //<-- SEE HERE
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.grey), //<-- SEE HERE
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 18),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w300),
                                      hintText: 'Nhập tên',
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Số điện thoại",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            FutureBuilder(
                              future: callProfile(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: "${snapshot.data["email"]}"),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      filled: true, //<-- SEE HERE
                                      fillColor: Colors.grey[200],
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary), //<-- SEE HERE
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.grey), //<-- SEE HERE
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 18),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w300),
                                      hintText: 'Nhập số điện thoại',
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                child: const Text(
                                  "Ngày đặt lịch",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Column(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              if (showDay) {
                                                _animationController2.reverse(
                                                    from: 0.5);
                                              } else {
                                                _animationController2.forward(
                                                    from: 0.0);
                                              }

                                              showDay = !showDay;
                                            });
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                    horizontal: 15)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                DateFormat("dd/MM/yyy").format(
                                                    DateTime.parse(
                                                        _singleDatePickerValueWithDefaultValue[
                                                                0]
                                                            .toString())),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              RotationTransition(
                                                turns: Tween(
                                                        begin: 0.0, end: 1.0)
                                                    .animate(
                                                        _animationController2),
                                                child: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          )),
                                      AnimatedCrossFade(
                                          firstChild: Container(),
                                          secondChild: Container(
                                            margin: const EdgeInsets.only(
                                                top: 2,
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(4,
                                                      4), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child:
                                                  _buildDefaultSingleDatePickerWithValue(),
                                            ),
                                          ),
                                          crossFadeState: showDay
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                          duration: 500.ms)
                                    ],
                                  )),
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 7),
                                  child: const Text(
                                    "Giờ đặt lịch",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (showTime) {
                                                  _animationController3.reverse(
                                                      from: 0.5);
                                                } else {
                                                  _animationController3.forward(
                                                      from: 0.0);
                                                }

                                                showTime = !showTime;
                                              });
                                            },
                                            style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 14,
                                                          horizontal: 15)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  activeTime.isNotEmpty
                                                      ? "${DateFormat("HH").format(DateTime.parse("$activeYear-$activeMonth-${activeDay}T$activeTime:00.000Z"))} giờ ${DateFormat("mm").format(DateTime.parse("$activeYear-$activeMonth-${activeDay}T$activeTime:00.000Z"))} phút"
                                                      : "Chọn giờ",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                RotationTransition(
                                                  turns: Tween(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(
                                                          _animationController3),
                                                  child: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            )),
                                        AnimatedCrossFade(
                                            firstChild: Container(),
                                            secondChild: FutureBuilder(
                                              future: callTimeBookingApi(
                                                  chiNhanh["ma_kho"],
                                                  "$activeYear-$activeMonth-$activeDay"),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 8,
                                                            offset: const Offset(
                                                                4,
                                                                4), // changes position of shadow
                                                          )
                                                        ],
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10))),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 2,
                                                            left: 10,
                                                            right: 10,
                                                            bottom: 10),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    child: Wrap(
                                                        alignment: WrapAlignment
                                                            .center,
                                                        runSpacing: 10,
                                                        spacing: 5,
                                                        children: snapshot.data!
                                                            .map((item) {
                                                          DateTime now =
                                                              DateTime.now();
                                                          DateTime dataBooking =
                                                              DateTime.parse(
                                                                  "$activeYear-$activeMonth-${activeDay}T${item["time"]}:00.000Z");
                                                          return GestureDetector(
                                                              onTap: () {
                                                                if (item[
                                                                        "value"] ==
                                                                    true) {
                                                                } else {
                                                                  if (DateTime(
                                                                          dataBooking
                                                                              .year,
                                                                          dataBooking
                                                                              .month,
                                                                          dataBooking
                                                                              .day,
                                                                          dataBooking
                                                                              .hour,
                                                                          dataBooking
                                                                              .minute,
                                                                          dataBooking
                                                                              .second)
                                                                      .isAfter(DateTime(
                                                                              now.year,
                                                                              now.month,
                                                                              now.day,
                                                                              now.hour,
                                                                              now.minute,
                                                                              now.second)
                                                                          .add(const Duration(minutes: 30)))) {
                                                                    chooseTime(item[
                                                                        "time"]);
                                                                  } else {
                                                                    showAlertDialog(
                                                                        context,
                                                                        "Bạn vui lòng đặt lịch trước 30 phút");
                                                                  }
                                                                }
                                                              },
                                                              child: Stack(
                                                                clipBehavior:
                                                                    Clip.none,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            6),
                                                                    decoration: BoxDecoration(
                                                                        color: item["value"] == true
                                                                            ? Colors.grey[
                                                                                350]
                                                                            : Colors
                                                                                .white,
                                                                        border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color: Theme.of(context).colorScheme.primary.withOpacity(activeTime == item["time"]
                                                                                ? 1
                                                                                : 0.1)),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(10))),
                                                                    width: MediaQuery.of(context).size.width /
                                                                            3 -
                                                                        35,
                                                                    child: Text(
                                                                      DateFormat(
                                                                              "HH:mm")
                                                                          .format(
                                                                              dataBooking),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                  if (activeTime ==
                                                                      item[
                                                                          "time"])
                                                                    Positioned(
                                                                      right: -1,
                                                                      top: -1,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            8,
                                                                        height:
                                                                            8,
                                                                        decoration: const BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                      ),
                                                                    )
                                                                ],
                                                              ));
                                                        }).toList()),
                                                  );
                                                } else {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            ),
                                            crossFadeState: showTime
                                                ? CrossFadeState.showSecond
                                                : CrossFadeState.showFirst,
                                            duration: 500.ms)
                                      ],
                                    )),
                              ])),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Dịch vụ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (showService) {
                                            _animationController.reverse(
                                                from: 0.5);
                                          } else {
                                            _animationController.forward(
                                                from: 0.0);
                                          }
                                          showService = !showService;
                                        });
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 15)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            activeService.isNotEmpty
                                                ? "${activeService["ten_vt"]}"
                                                : "Chọn dịch vụ",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          RotationTransition(
                                            turns: Tween(begin: 0.0, end: 1.0)
                                                .animate(_animationController),
                                            child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      )),
                                  chooseServiceWidget(
                                      (index) => showServiceLevel1(index),
                                      (index, index2) =>
                                          showServiceLevel2(index, index2),
                                      (item) => chooseActiveService(item),
                                      activeService)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 20)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary)),
                        onPressed: () {
                          if (activeTime.isEmpty) {
                            showAlertDialog(
                                context, "Bạn chưa chọn giờ đặt lịch");
                            setState(() {
                              showTime = true;
                            });
                          } else if (activeService.isEmpty) {
                            showAlertDialog(context, "Bạn chưa chọn dịch vụ");
                            setState(() {
                              showService = true;
                            });
                          } else {
                            showModalInfo();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(flex: 1, child: Container()),
                            const Expanded(
                              flex: 8,
                              child: Center(
                                child: Text(
                                  "Đặt lịch ngay",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/calendar-white.png",
                                width: 28,
                                height: 28,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        )),
                  )
                ])));
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: Theme.of(context).colorScheme.primary,
      weekdayLabels: weekDaysName,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      dayTextStyle: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
      disabledDayTextStyle:
          const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
      selectableDayPredicate: (day) => !day
          .difference(DateTime.now().subtract(const Duration(days: 1)))
          .isNegative,
      customModePickerIcon: Container(),
      modePickerTextHandler: ({DateTime? monthDate}) {
        return "Tháng ${monthDate?.month}, ${monthDate?.year}";
      },
    );
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CalendarDatePicker2(
            config: config,
            value: _singleDatePickerValueWithDefaultValue,
            onValueChanged: (dates) => setState(() {
                  _singleDatePickerValueWithDefaultValue = dates;
                  activeTime = "";
                })));
  }
}

Widget chooseServiceWidget(
    Function(int index) showLevel1,
    Function(int index, int index2) showLevel2,
    Function(Map item) chooseActive,
    Map activeService) {
  return AnimatedCrossFade(
      firstChild: Container(),
      secondChild: Column(
          children: chooseService.map((item) {
        int index = chooseService.indexOf(item);
        return Column(
          children: [
            SizedBox(
                child: Column(
              children: [
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextButton(
                    onPressed: () {
                      showLevel1(index);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              item["icon"],
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              item["title"],
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: item["child"] != null
                        ? Column(
                            children: item["child"]!.map<Widget>((it) {
                              int index2 = item["child"]!.indexOf(it);
                              return Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      height: 55,
                                      child: TextButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.only(
                                                    top: 5,
                                                    bottom: 5,
                                                    left: 0,
                                                    right: 25))),
                                        onPressed: () {
                                          showLevel2(index, index2);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${it["title"]}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      )),
                                  AnimatedCrossFade(
                                      firstChild: Container(),
                                      secondChild: FutureBuilder(
                                        future: callServiceApi(it["category"]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    snapshot.data!.map((abc) {
                                                  int index3 = snapshot.data!
                                                      .indexOf(abc);
                                                  return Container(
                                                      margin: EdgeInsets.only(
                                                          left: 30,
                                                          right: 30,
                                                          top: index3 == 0
                                                              ? 0
                                                              : 15),
                                                      child: Stack(
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                chooseActive(
                                                                    abc);
                                                              },
                                                              style: ButtonStyle(
                                                                  padding: MaterialStateProperty.all(const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          0)),
                                                                  shape: MaterialStateProperty.all(
                                                                      const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))))),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                    child: Image
                                                                        .network(
                                                                      "$apiUrl${abc["picture"]}?$token",
                                                                      height:
                                                                          180,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 10,
                                                                        bottom:
                                                                            15),
                                                                    child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            abc["ten_vt"],
                                                                            style:
                                                                                const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    NumberFormat.currency(locale: "vi_VI", symbol: "").format(
                                                                                      abc["gia_ban_le"],
                                                                                    ),
                                                                                    style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                                                                                  ),
                                                                                  const Text(
                                                                                    "đ",
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      decoration: TextDecoration.underline,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              const Text(
                                                                                "Đánh giá: ",
                                                                                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                                                                              ),
                                                                              Wrap(
                                                                                children: [
                                                                                  const Icon(
                                                                                    Icons.star,
                                                                                    size: 20,
                                                                                    color: Colors.orange,
                                                                                  ),
                                                                                  const Icon(
                                                                                    Icons.star,
                                                                                    size: 20,
                                                                                    color: Colors.orange,
                                                                                  ),
                                                                                  const Icon(
                                                                                    Icons.star,
                                                                                    size: 20,
                                                                                    color: Colors.orange,
                                                                                  ),
                                                                                  const Icon(
                                                                                    Icons.star,
                                                                                    size: 20,
                                                                                    color: Colors.orange,
                                                                                  ),
                                                                                  Icon(
                                                                                    index3 % 2 == 0 ? Icons.star : Icons.star_half,
                                                                                    size: 20,
                                                                                    color: Colors.orange,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )
                                                                        ]),
                                                                  )
                                                                ],
                                                              )),
                                                          if (activeService
                                                              .isNotEmpty)
                                                            if (activeService[
                                                                    "_id"] ==
                                                                abc["_id"])
                                                              Positioned.fill(
                                                                  child:
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.4),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                                ),
                                                                child:
                                                                    const Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .check_circle_outline,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50,
                                                                  ),
                                                                ),
                                                              ))
                                                        ],
                                                      ));
                                                }).toList());
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                      crossFadeState:
                                          it["show_category"] == true
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                      duration: 500.ms)
                                ],
                              );
                            }).toList(),
                          )
                        : Container(),
                    crossFadeState: item["show"] == true
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: 500.ms),
                if (item["id"] != null)
                  AnimatedCrossFade(
                      firstChild: Container(),
                      secondChild: FutureBuilder(
                        future: callServiceApi(item["id"]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: snapshot.data!.map((abc) {
                              int index3 = snapshot.data!.indexOf(abc);
                              return Container(
                                  margin: EdgeInsets.only(
                                      left: 30,
                                      right: 30,
                                      top: index3 == 0 ? 0 : 15),
                                  child: Stack(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            chooseActive(abc);
                                          },
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets.all(0)),
                                              shape: MaterialStateProperty.all(
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  "$apiUrl${abc["picture"]}?$token",
                                                  height: 180,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 10,
                                                    bottom: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      abc["ten_vt"],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              NumberFormat.currency(
                                                                      locale:
                                                                          "vi_VI",
                                                                      symbol:
                                                                          "")
                                                                  .format(
                                                                abc["gia_ban_le"],
                                                              ),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            const Text(
                                                              "đ",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Đánh giá: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Wrap(
                                                          children: [
                                                            const Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            const Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            const Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            const Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              index3 % 2 == 0
                                                                  ? Icons.star
                                                                  : Icons
                                                                      .star_half,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                      if (activeService.isNotEmpty)
                                        if (activeService["_id"] == abc["_id"])
                                          Positioned.fill(
                                              child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ));
                            }).toList());
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      crossFadeState: item["show"] == true
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: 500.ms)
              ],
            )),
            if (index < chooseService.length - 1)
              Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final boxWidth = constraints.constrainWidth();
                      double dashWidth = 10.0;
                      double dashHeight = 1;
                      final dashCount = (boxWidth / (2 * dashWidth)).floor();
                      return Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        children: List.generate(dashCount, (_) {
                          return SizedBox(
                            width: dashWidth,
                            height: dashHeight,
                            child: DecoratedBox(
                              decoration:
                                  BoxDecoration(color: Colors.grey[300]),
                            ),
                          );
                        }),
                      );
                    },
                  )),
            if (index == chooseService.length - 1)
              Container(
                height: 10,
              )
          ],
        );
      }).toList()),
      crossFadeState:
          !showService ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: 500.ms);
}
