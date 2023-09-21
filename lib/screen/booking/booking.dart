import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/booking_success.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_dia_chi.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
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
DateTime now = DateTime.now();
DateTime? activeDate;
TimeOfDay? activeTime;
String tenkh = "";
String tokenfirebase = "";
Map activeService = {};
List chooseService = [];

class _BookingServicesState extends State<BookingServices>
    with TickerProviderStateMixin {
  NotificationService notificationService = NotificationService();
  final DataCustom dataCustom = DataCustom();
  final ProfileModel profileModel = ProfileModel();
  final ServicesModel servicesModel = ServicesModel();
  final CustomModal customModal = CustomModal();
  final BookingModel bookingModel = BookingModel();
  late AnimationController _animationController;
  final LocalStorage storageBranch = LocalStorage('branch');

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        upperBound: 0.5);
    _animationController.reverse();
    notificationService.requestNotificationPermission();
    notificationService.setupFlutterNotifications();
    notificationService.setupInteractMessage(context);
    // notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value) {
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
      chooseService.clear();
    });
    servicesModel.getGroupServiceByBranch().then((value) {
      for (var i = 0; i < value.length; i++) {
        setState(() {
          chooseService.add({
            "show": widget.dichvudachon == null
                ? false
                : value[i]["GroupCode"] == widget.dichvudachon!["CategoryCode"]
                    ? true
                    : false,
            "name": value[i]["GroupName"],
            "code": value[i]["GroupCode"],
          });
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    activeService = {};
    chooseService.clear();
    super.dispose();
  }

  void showServiceChoseService(int index) {
    setState(() {
      chooseService[index]["show"] = !chooseService[index]["show"];
    });
  }

  void saveCN() {
    setState(() {});
  }

  void chooseActiveService(Map item) {
    setState(() {
      activeService = item;
    });
  }

  void selectDate() async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 100, now.month, now.day));
    if (selectedDate != null) {
      setState(() {
        activeDate = selectedDate;
      });
    }
  }

  void selectTime() async {
    TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        activeTime = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map branch = jsonDecode(storageBranch.getItem("branch"));
    tz.TZDateTime nextInstanceOfTenAM() {
      tz.initializeTimeZones();
      int hours = DateTime.parse("$activeTime:00.000Z").hour;
      late tz.TZDateTime now =
          tz.TZDateTime.now(tz.getLocation("Asia/Ho_Chi_Minh"));
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.getLocation("Asia/Ho_Chi_Minh"),
        activeDate!.year,
        activeDate!.month,
        activeDate!.day,
        hours - 1,
        30,
      );
      // if (scheduledDate.isBefore(now)) {
      //   scheduledDate = scheduledDate.add(const Duration(days: 1));
      // }

      return scheduledDate;
    }
print(activeService);
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

    void addBookingService(){
      print(activeService);
      if(activeDate == null){
        customModal.showAlertDialog(context, "error", "Lỗi Đặt Lịch", "Bạn chưa chọn ngày đặt lịch", (){
          Navigator.pop(context);
          selectDate();
        }, () => Navigator.pop(context));
      }
      else if (activeTime == null) {
        customModal.showAlertDialog(context, "error", "Lỗi Đặt Lịch", "Bạn chưa chọn giời đặt lịch", () {
          Navigator.pop(context);
          selectTime();
        }, () => Navigator.pop(context));
      } else if (activeService.isEmpty) {
        customModal.showAlertDialog(context, "error", "Lỗi Đặt Lịch", "Bạn chưa chọn dịch vụ đặt lịch", () => Navigator.pop(context), () => Navigator.pop(context));
      } else {
        DateTime dateBook = DateTime(activeDate!.year, activeDate!.month, activeDate!.day, activeTime!.hour, activeTime!.minute);
        Map data = {
          "branchCode": jsonDecode(storageBranch.getItem("branch"))["Code"],
          "StartDate":"$dateBook",
          "DueDate":"",
          "Note":"",
          "DetailList":
          [
             activeService["Id"],
          ]
        };
        customModal.showAlertDialog(context, "error", "Xác Nhận Đặt Lịch",
            "Bạn có chắc chắn chọn đặt lịch này không?", () {
              Navigator.pop(context);
              EasyLoading.show(status: "Vui lòng chờ...");
              Future.delayed(const Duration(seconds: 2), () {
                bookingModel.setBookingService(data).then((value) {
                  EasyLoading.dismiss();

                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookingSuccess(details: value,)));
                });
              });
            }, () => Navigator.pop(context));
      }
    }
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
              title: const Text("Đặt lịch",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: Column(
                // reverse: true,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      const SizedBox(
                        height: 15,
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
                              Row(
                                children: [
                                  Expanded(
                                    flex: 48,
                                    child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: activeDate != null
                                              ? DateFormat("dd/MM/yyyy")
                                                  .format(activeDate!)
                                              : ""),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      onTap: () => selectDate(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                      decoration: InputDecoration(
                                        focusedBorder: dataCustom.border,
                                        border: dataCustom.border,
                                        suffixIcon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 18),
                                        hintStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                        hintText: 'Chọn ngày',
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Container()),
                                  Expanded(
                                      flex: 48,
                                      child: TextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: activeTime == null
                                                ? ""
                                                : DateFormat("HH:mm").format(
                                                    DateTime(
                                                        now.year,
                                                        now.month,
                                                        now.day,
                                                        activeTime!.hour,
                                                        activeTime!.minute))),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        onTap: () => selectTime(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                        decoration: InputDecoration(
                                          focusedBorder: dataCustom.border,
                                          border: dataCustom.border,
                                          suffixIcon: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 18),
                                          hintStyle: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                          hintText: 'Chọn giờ',
                                        ),
                                      ))
                                ],
                              ),
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
                                  "Đặt lịch tại",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: "${branch["Name"]}"),
                                textAlignVertical: TextAlignVertical.center,
                                onTap: () => showModalBottomSheet<void>(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .96,
                                        child: ModalDiaChi(
                                          saveCN: saveCN,
                                        ),
                                      );
                                    }),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  focusedBorder: dataCustom.border,
                                  border: dataCustom.border,
                                  suffixIcon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                ),
                              ),
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
                                "Dịch vụ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          Expanded(
                                            child: Text(
                                              activeService.isNotEmpty
                                                  ? "${activeService["Name"][0].toString().toUpperCase()}${activeService["Name"].toString().substring(1).toLowerCase()}"
                                                  : "Chọn dịch vụ",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300),
                                            ),
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
                                  AnimatedCrossFade(
                                      firstChild: Container(),
                                      secondChild: chooseService.isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:
                                                  chooseService.map((item) {
                                                int index =
                                                    chooseService.indexOf(item);
                                                return Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15),
                                                    child: Column(
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              showServiceChoseService(
                                                                  index);
                                                            },
                                                            style: ButtonStyle(
                                                                padding: MaterialStateProperty.all(
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            15,
                                                                        horizontal:
                                                                            20)),
                                                                shape: MaterialStateProperty.all(
                                                                    const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  item["name"],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.6),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                item["show"]
                                                                    ? const Icon(
                                                                        Icons
                                                                            .keyboard_arrow_up,
                                                                        color: Colors
                                                                            .black)
                                                                    : const Icon(
                                                                        Icons
                                                                            .keyboard_arrow_down,
                                                                        color: Colors
                                                                            .black)
                                                              ],
                                                            )),
                                                        AnimatedCrossFade(
                                                            firstChild:
                                                                Container(),
                                                            secondChild:
                                                                FutureBuilder(
                                                                    future: servicesModel
                                                                        .getServiceByGroup(item[
                                                                            "name"]),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        return Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: snapshot.data!.map((abc) {
                                                                              int index3 = snapshot.data!.indexOf(abc);
                                                                              return Container(
                                                                                margin: EdgeInsets.only(left: 15, right: 15, top: index3 == 0 ? 0 : 15),
                                                                                child: TextButton(
                                                                                    onPressed: () {
                                                                                      chooseActiveService(abc);
                                                                                    },
                                                                                    style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 15)), shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))),
                                                                                    child: Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Container(
                                                                                          alignment: Alignment.center,
                                                                                          width: 24,
                                                                                          height: 24,
                                                                                          decoration: BoxDecoration(color: activeService["Code"] == abc["Code"] ? Colors.green : Colors.white, border: Border.all(width: 1, color: activeService["Code"] == abc["Code"] ? Colors.green : Colors.black), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                                                                          child: GestureDetector(
                                                                                              child: activeService["Code"] == abc["Code"]
                                                                                                  ? const Icon(
                                                                                                      Icons.check,
                                                                                                      color: Colors.white,
                                                                                                      size: 16,
                                                                                                    )
                                                                                                  : Container()),
                                                                                        ),
                                                                                        Expanded(
                                                                                            child: Container(
                                                                                          margin: const EdgeInsets.symmetric(horizontal: 12),
                                                                                          child: Text(
                                                                                            "${abc["Name"][0].toString().toUpperCase()}${abc["Name"].toString().substring(1).toLowerCase()}",
                                                                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                          ),
                                                                                        )),
                                                                                        Text(
                                                                                          NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(abc["PriceOutbound"]),
                                                                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                        )
                                                                                      ],
                                                                                    )),
                                                                              );
                                                                            }).toList());
                                                                      } else {
                                                                        return const Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 40,
                                                                              height: 40,
                                                                              child: LoadingIndicator(
                                                                                colors: kDefaultRainbowColors,
                                                                                indicatorType: Indicator.lineSpinFadeLoader,
                                                                                strokeWidth: 1,
                                                                                // pathBackgroundColor: Colors.black45,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text("Đang lấy dữ liệu")
                                                                          ],
                                                                        );
                                                                      }
                                                                    }),
                                                            crossFadeState: item[
                                                                    "show"]
                                                                ? CrossFadeState
                                                                    .showSecond
                                                                : CrossFadeState
                                                                    .showFirst,
                                                            duration: 500.ms)
                                                      ],
                                                    ));
                                              }).toList())
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: LoadingIndicator(
                                                    colors:
                                                        kDefaultRainbowColors,
                                                    indicatorType: Indicator
                                                        .lineSpinFadeLoader,
                                                    strokeWidth: 1,
                                                    // pathBackgroundColor: Colors.black45,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Đang lấy dữ liệu")
                                              ],
                                            ),
                                      crossFadeState: showService == true
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      duration: 500.ms)
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

                          addBookingService();
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
}
