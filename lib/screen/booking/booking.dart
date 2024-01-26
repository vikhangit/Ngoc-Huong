import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/branchsModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/booking_success.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:upgrader/upgrader.dart';

class BookingServices extends StatefulWidget {
  final Map? dichvudachon;
  const BookingServices({super.key, this.dichvudachon});
  @override
  State<BookingServices> createState() => _BookingServicesState();
}

bool showService = true;
bool showDay = false;
bool showTime = false;
bool showBranch = false;
DateTime now = DateTime.now();
DateTime? activeDate;
TimeOfDay? activeTime;
String tenkh = "";
String tokenfirebase = "";
Map activeBranch = {};
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
  late AnimationController _animationController1;
  final BranchsModel branchsModel = BranchsModel();
  final LocalStorage storageBranch = LocalStorage('branch');
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        upperBound: 0.5);
    _animationController.reverse();
    _animationController1 = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        upperBound: 0.5);
    _animationController1.reverse();
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
          if (value[i]["GroupCode"] == "Phun thêu thẩm mỹ") {
            chooseService.insert(0, {
              "show": widget.dichvudachon == null
                  ? false
                  : value[i]["GroupCode"] ==
                          widget.dichvudachon!["CategoryCode"]
                      ? true
                      : false,
              "name": value[i]["GroupName"],
              "code": value[i]["GroupCode"],
            });
          } else if (value[i]["GroupCode"] == "Điều trị da" ||
              value[i]["GroupCode"] == "Trẻ hóa & chăm sóc da" ||
              value[i]["GroupCode"] == "Triệt Lông") {
            chooseService.add({
              "show": widget.dichvudachon == null
                  ? false
                  : value[i]["GroupCode"] ==
                          widget.dichvudachon!["CategoryCode"]
                      ? true
                      : false,
              "name": value[i]["GroupName"],
              "code": value[i]["GroupCode"],
            });
          }
        });
      }
    });

    Map active = storageBranch.getItem("branch") != null
        ? jsonDecode(storageBranch.getItem("branch"))
        : {};
    setState(() {
      activeBranch = active;
    });
    Upgrader.clearSavedSettings();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    activeService = {};
    activeDate = null;
    activeTime = null;
    chooseService.clear();
    scrollController.dispose();
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
    TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (result != null) {
      setState(() {
        activeTime = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map branch = storageBranch.getItem("branch") == null
        ? {}
        : jsonDecode(storageBranch.getItem("branch"));
    tz.TZDateTime nextInstanceOfTenAM() {
      tz.initializeTimeZones();
      late tz.TZDateTime now =
          tz.TZDateTime.now(tz.getLocation("Asia/Ho_Chi_Minh"));
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.getLocation("Asia/Ho_Chi_Minh"),
        activeDate!.year,
        activeDate!.month,
        activeDate!.day,
        activeTime!.hour - 1,
        30,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      print(scheduledDate);
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
                "Hôm nay bạn có lịch hẹn ${activeService["Name"][0].toString().toUpperCase()}${activeService["Name"].toString().substring(1).toLowerCase()} lúc ${activeTime!.hour}:${activeTime!.minute} tại Ngọc Hường",
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

    void addBookingService() {
      if (activeDate == null) {
        customModal.showAlertDialog(
            context, "error", "Lỗi Đặt Lịch", "Bạn chưa chọn ngày đặt lịch",
            () {
          Navigator.of(context).pop();
          selectDate();
        }, () => Navigator.of(context).pop());
      } else if (activeTime == null) {
        customModal.showAlertDialog(
            context, "error", "Lỗi Đặt Lịch", "Bạn chưa chọn giờ đặt lịch", () {
          Navigator.of(context).pop();
          selectTime();
        }, () => Navigator.of(context).pop());
      } else if (activeBranch.isEmpty) {
        customModal.showAlertDialog(
            context,
            "error",
            "Lỗi Đặt Lịch",
            "Bạn chưa chọn chi nhánh",
            () => Navigator.of(context).pop(),
            () => Navigator.of(context).pop());
      } else if (activeService.isEmpty) {
        customModal.showAlertDialog(
            context,
            "error",
            "Lỗi Đặt Lịch",
            "Bạn chưa chọn dịch vụ đặt lịch",
            () => Navigator.of(context).pop(),
            () => Navigator.of(context).pop());
      } else {
        DateTime dateBook = DateTime(activeDate!.year, activeDate!.month,
            activeDate!.day, activeTime!.hour, activeTime!.minute);
        DateTime dateOpen = DateTime(
            activeDate!.year, activeDate!.month, activeDate!.day, 8, 0);
        DateTime dateClose = DateTime(
            activeDate!.year, activeDate!.month, activeDate!.day, 19, 0);
        DateTime now = DateTime.now();
        if (dateBook.isBefore(dateOpen) || dateBook.isAfter(dateClose)) {
          customModal.showAlertDialog(context, "error", "Lỗi Đặt Lịch",
              "Bạn đã chọn đặt lịch vào thời gian Ngọc Hường chưa mở cửa", () {
            Navigator.of(context).pop();
            selectTime();
          }, () => Navigator.of(context).pop());
        } else {
          if (dateBook.isAfter(now)) {
            Map data = {
              "branchCode": activeBranch["Code"],
              "StartDate": "$dateBook",
              "DueDate": "",
              "Note": "",
              "DetailList": [
                activeService["Id"],
              ]
            };
            print(data);
            customModal.showAlertDialog(context, "error", "Xác Nhận Đặt Lịch",
                "Bạn có chắc chắn chọn đặt lịch này không?", () {
              Navigator.of(context).pop();
              EasyLoading.show(status: "Vui lòng chờ...");
              Future.delayed(const Duration(seconds: 2), () {
                bookingModel.setBookingService(data).then((value) {
                  // sendNotifications();
                  EasyLoading.dismiss();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingSuccess(
                                details: value,
                              )));
                });
              });
            }, () => Navigator.of(context).pop());
          } else {
            customModal.showAlertDialog(
                context,
                "error",
                "Lỗi Đặt Lịch",
                "Không thể đặt lịch với thời gian trong quá khứ",
                () => Navigator.of(context).pop(),
                () => Navigator.of(context).pop());
          }
        }
      }
    }

    return SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
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
              title: const Text("Đặt lịch",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: 100,
                child: const MyBottomMenu(
                  active: 1,
                )),
            body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: Column(
                    // reverse: true,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ListView(
                        // controller: scrollController,
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
                                            enabledBorder: dataCustom.border,
                                            suffixIcon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 18),
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
                                                    : DateFormat("HH:mm")
                                                        .format(DateTime(
                                                            now.year,
                                                            now.month,
                                                            now.day,
                                                            activeTime!.hour,
                                                            activeTime!
                                                                .minute))),
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            onTap: () => selectTime(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                            decoration: InputDecoration(
                                              focusedBorder: dataCustom.border,
                                              enabledBorder: dataCustom.border,
                                              suffixIcon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 18),
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
                                  Container(
                                    // padding: const EdgeInsets.only(bottom: 10),

                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (showBranch) {
                                                  _animationController1.reverse(
                                                      from: 0.5);
                                                } else {
                                                  _animationController1.forward(
                                                      from: 0.0);
                                                }
                                                showBranch = !showBranch;
                                              });
                                            },
                                            style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16,
                                                          horizontal: 15)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    activeBranch.isNotEmpty
                                                        ? "${activeBranch["Name"]}"
                                                        : "Chọn chi nhánh",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                                RotationTransition(
                                                  turns: Tween(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(
                                                          _animationController1),
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
                                                future:
                                                    branchsModel.getBranchs(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: snapshot.data!
                                                            .map((item) {
                                                          int index = snapshot
                                                              .data!
                                                              .indexOf(item);
                                                          print(item);
                                                          if (item["Name"] ==
                                                              "Kho miền bắc") {
                                                            return Container();
                                                          } else {
                                                            return TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    activeBranch =
                                                                        item;
                                                                    showBranch =
                                                                        false;
                                                                    _animationController1
                                                                        .reverse(
                                                                            from:
                                                                                0.5);
                                                                  });
                                                                },
                                                                style: ButtonStyle(
                                                                    padding: MaterialStateProperty.all(const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            15,
                                                                        horizontal:
                                                                            20)),
                                                                    shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))))),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      item[
                                                                          "Name"],
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    activeBranch["Code"] ==
                                                                            item["Code"]
                                                                        ? const Icon(
                                                                            Icons.check,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.green,
                                                                          )
                                                                        : Container()
                                                                  ],
                                                                ));
                                                          }
                                                        }).toList());
                                                  } else {
                                                    return const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child:
                                                              LoadingIndicator(
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
                                                    );
                                                  }
                                                }),
                                            crossFadeState: showBranch
                                                ? CrossFadeState.showSecond
                                                : CrossFadeState.showFirst,
                                            duration: 500.ms)
                                      ],
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
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  // padding: const EdgeInsets.only(bottom: 10),

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    vertical: 16,
                                                    horizontal: 15)),
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
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                              RotationTransition(
                                                turns: Tween(
                                                        begin: 0.0, end: 1.0)
                                                    .animate(
                                                        _animationController),
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
                                                    int index = chooseService
                                                        .indexOf(item);
                                                    if (item["name"] !=
                                                        "Sản phẩm") {
                                                      return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Column(
                                                            children: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    showServiceChoseService(
                                                                        index);
                                                                  },
                                                                  style: ButtonStyle(
                                                                      padding: MaterialStateProperty.all(const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              15,
                                                                          horizontal:
                                                                              20)),
                                                                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))))),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        item[
                                                                            "name"],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black.withOpacity(0.6),
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                      item["show"]
                                                                          ? const Icon(Icons.keyboard_arrow_up,
                                                                              color: Colors
                                                                                  .black)
                                                                          : const Icon(
                                                                              Icons.keyboard_arrow_down,
                                                                              color: Colors.black)
                                                                    ],
                                                                  )),
                                                              AnimatedCrossFade(
                                                                  firstChild:
                                                                      Container(),
                                                                  secondChild:
                                                                      FutureBuilder(
                                                                          future: servicesModel.getServiceByGroup(item[
                                                                              "code"]),
                                                                          builder: (context,
                                                                              snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              return Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                              // Text(
                                                                                              //   NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(abc["PriceOutbound"]),
                                                                                              //   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                              // )
                                                                                            ],
                                                                                          )),
                                                                                    );
                                                                                  }).toList());
                                                                            } else {
                                                                              return const Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                                                  duration:
                                                                      500.ms)
                                                            ],
                                                          ));
                                                    } else {
                                                      return Container();
                                                    }
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)))),
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
                    ]))));
  }
}
