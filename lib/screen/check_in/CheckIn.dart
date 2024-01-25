import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:upgrader/upgrader.dart';

class CheckIn extends StatefulWidget {
  final Function save;
  const CheckIn({super.key, required this.save});

  @override
  State<CheckIn> createState() => _CheckInState();
}

bool showMore = false;
List checkInList = [];
Map profile = {};
bool isLoading = false;

class _CheckInState extends State<CheckIn> with TickerProviderStateMixin {
  final ServicesModel servicesModel = ServicesModel();
  final CheckInModel checkInModel = CheckInModel();
  final LocalStorage storageToken = LocalStorage("customer_token");
  final ProfileModel profileModel = ProfileModel();
  final ScrollController scrollController = ScrollController();
  final CustomModal customModal = CustomModal();
  late AnimationController _animationController;
  @override
  initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        upperBound: 0.5);
    _animationController.reverse();
    setState(() {
      isLoading = true;
    });
    checkInModel.getCheckInList().then((value) => setState(() {
          checkInList = value.toList();
        }));
    profileModel.getProfile().then((value) {
      setState(() {
        profile = value;
      });
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    scrollController.dispose();
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("========================");
    print(profile["Phone"]);
    List diemdanh = checkInList
        .where((element) => element["device_user_id"] == profile["Phone"])
        .toList();
    String convertTime(String date, bool n) {
      DateTime a;
      if (!n) {
        a = DateTime.parse(date).add(const Duration(hours: 7));
      } else {
        a = DateTime.now();
      }
      int day = a.day;
      int month = a.month;
      int year = a.year;

      return "${day < 10 ? "0$day" : "$day"}/${month < 10 ? "0$month" : "$month"}/$year";
    }

    void handleCheckIn(int index, bool show) {
      if (diemdanh.isEmpty) {
        if (index + int.parse('${!show ? 0 : 7}') > 0) {
          customModal.showAlertDialog(
              context,
              "error",
              "Lỗi điểm danh",
              "Bạn hãy điểm danh ngày ${diemdanh.length + 1} trước",
              () => Navigator.of(context).pop(),
              () => Navigator.of(context).pop());
        } else {
          EasyLoading.show(status: "Đang xử lý");
          Future.delayed(const Duration(seconds: 1), () {
            checkInModel.addCheckIn({
              "record_time": DateTime.now().toIso8601String(),
              "device_user_id": "${profile["Phone"]}"
            }).then((value) {
              EasyLoading.dismiss();
              setState(() {
                checkInModel.getCheckInList().then((value) => setState(() {
                      checkInList = value.toList();
                    }));
              });
              diemdanh = checkInList
                  .where((element) =>
                      element["device_user_id"] == profile["Phone"])
                  .toList();
            });
          });
        }
      } else if (index + 1 + int.parse('${!show ? 0 : 7}') <= diemdanh.length) {
        customModal.showAlertDialog(
            context,
            "error",
            "Điểm danh",
            "Bạn đã điểm danh ngày này rồi",
            () => Navigator.of(context).pop(),
            () => Navigator.of(context).pop());
      } else if (convertTime(diemdanh[0]["record_time"], false) ==
          convertTime(DateTime.now().toIso8601String(), true)) {
        customModal.showAlertDialog(
            context,
            "error",
            "Điểm danh",
            "Hôm nay bạn đã điểm danh rồi hãy quay lại vào ngày mai nhé!",
            () => Navigator.of(context).pop(),
            () => Navigator.of(context).pop());
      } else if (index + int.parse('${!show ? 0 : 7}') > diemdanh.length) {
        customModal.showAlertDialog(
            context,
            "error",
            "Lỗi điểm danh",
            "Bạn hãy điểm danh ngày ${diemdanh.length + 1} trước",
            () => Navigator.of(context).pop(),
            () => Navigator.of(context).pop());
      } else if (convertTime(diemdanh[0]["record_time"], false) !=
          convertTime(DateTime.now().toIso8601String(), true)) {
        EasyLoading.show(status: "Đang xử lý");
        Future.delayed(const Duration(seconds: 1), () {
          checkInModel.addCheckIn({
            "record_time": DateTime.now().toIso8601String(),
            "device_user_id": "${profile["Phone"]}"
          }).then((value) {
            EasyLoading.dismiss();
            setState(() {
              checkInModel.getCheckInList().then((value) => setState(() {
                    checkInList = value.toList();
                  }));
            });
            diemdanh = checkInList
                .where(
                    (element) => element["device_user_id"] == profile["Phone"])
                .toList();
          });
        });
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: mainColor),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Điểm danh",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  child: Icon(Icons.close),
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 9,
                      children: List.generate(
                          7,
                          (index) => GestureDetector(
                                onTap: () {
                                  handleCheckIn(index, false);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              7 -
                                          14,
                                      margin: const EdgeInsets.only(bottom: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                          color: index + 1 <= diemdanh.length
                                              ? Colors.black.withOpacity(0.2)
                                              : Colors.white,
                                          border: Border.all(
                                              color:
                                                  index + 1 <= diemdanh.length
                                                      ? mainColor
                                                      : index + 1 == 7
                                                          ? Colors.amber
                                                          : mainColor),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Column(
                                        children: [
                                          Text(
                                            index + 1 == 7 ? "20" : "10",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    index + 1 <= diemdanh.length
                                                        ? Colors.black
                                                            .withOpacity(0.3)
                                                        : index + 1 == 7
                                                            ? Colors.amber
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .primary),
                                          ),
                                          index + 1 <= diemdanh.length
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: mainColor,
                                                  size: 20,
                                                )
                                              : index + 1 == 7
                                                  ? Image.asset(
                                                      "assets/images/giftbox.png",
                                                      width: 20,
                                                      height: 20,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/icon/Xu1.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Ngày ${index + 1}",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: index + 1 <= diemdanh.length
                                              ? Colors.black.withOpacity(0.3)
                                              : index + 1 == 7
                                                  ? Colors.amber
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                    )
                                  ],
                                ),
                              )),
                    ),
                    AnimatedCrossFade(
                        firstChild: Container(),
                        secondChild: Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 9,
                            runSpacing: 15,
                            children: List.generate(
                                21,
                                (index) => GestureDetector(
                                      onTap: () {
                                        // widget.checkInClick(index, true);
                                        handleCheckIn(index, true);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    7 -
                                                14,
                                            margin: const EdgeInsets.only(
                                                bottom: 2),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                                color: index + 1 + 7 <=
                                                        diemdanh.length
                                                    ? Colors.black
                                                        .withOpacity(0.2)
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: index + 1 + 7 <=
                                                            diemdanh.length
                                                        ? mainColor
                                                        : index + 1 == 7 ||
                                                                index + 1 ==
                                                                    14 ||
                                                                index + 1 == 21
                                                            ? Colors.amber
                                                            : mainColor),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4))),
                                            child: Column(
                                              children: [
                                                Text(
                                                  index + 1 == 7 ||
                                                          index + 1 == 14 ||
                                                          index + 1 == 21
                                                      ? "20"
                                                      : "10",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: index + 1 + 7 <=
                                                              diemdanh.length
                                                          ? Colors.black
                                                              .withOpacity(0.3)
                                                          : index + 1 == 7 ||
                                                                  index + 1 ==
                                                                      14 ||
                                                                  index + 1 ==
                                                                      21
                                                              ? Colors.amber
                                                              : Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                                ),
                                                index + 1 + 7 <= diemdanh.length
                                                    ? Icon(
                                                        Icons.check_circle,
                                                        size: 20,
                                                        color: mainColor,
                                                      )
                                                    : index + 1 == 7 ||
                                                            index + 1 == 14
                                                        ? Image.asset(
                                                            "assets/images/giftbox.png",
                                                            width: 20,
                                                            height: 20,
                                                          )
                                                        : index + 1 == 21
                                                            ? Image.asset(
                                                                "assets/images/award.png",
                                                                width: 20,
                                                                height: 20,
                                                              )
                                                            : Image.asset(
                                                                "assets/images/icon/Xu1.png",
                                                                width: 20,
                                                                height: 20,
                                                              )
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "Ngày ${index + 1 + 7}",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: index + 1 + 7 <=
                                                        diemdanh.length
                                                    ? Colors.black
                                                        .withOpacity(0.3)
                                                    : index + 1 == 7 ||
                                                            index + 1 == 14 ||
                                                            index + 1 == 21
                                                        ? Colors.amber
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                          )
                                        ],
                                      ),
                                    )),
                          ),
                        ),
                        crossFadeState: showMore
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: 500.milliseconds),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if (showMore) {
                        _animationController.reverse(from: 0.5);
                      } else {
                        _animationController.forward(from: 0.0);
                      }
                      showMore = !showMore;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          showMore ? "Thu gọn" : "Xem tất cả",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.8),
                              fontWeight: FontWeight.w700),
                        ),
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(_animationController),
                          child: Icon(
                            Icons.expand_more_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                            size: 16,
                            weight: 1,
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
