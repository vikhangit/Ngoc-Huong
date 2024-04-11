import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
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

  int checkLength(List a) {
    int length = 21;
    if (a.isEmpty) {
      return length = 21;
    } else if (a.length < 21) {
      return length = 21;
    } else if (a.length >= 21 && a.length < 42) {
      return length = 35;
    } else if (a.length >= 42 && a.length < 63) {
      return length = 49;
    } else if (a.length >= 63 && a.length < 84) {
      return length = 63;
    } else if (a.length >= 84 && a.length < 105) {
      return length = 77;
    } else if (a.length >= 105 && a.length < 126) {
      return length = 91;
    } else if (a.length >= 126 && a.length < 147) {
      return length = 105;
    } else if (a.length >= 147 && a.length < 168) {
      return length = 110;
    } else if (a.length >= 168 && a.length < 189) {
      return length = 133;
    } else if (a.length >= 189 && a.length < 210) {
      return length = 147;
    } else if (a.length >= 210 && a.length < 231) {
      return length = 161;
    } else if (a.length >= 231 && a.length < 252) {
      return length = 175;
    } else if (a.length >= 252 && a.length < 273) {
      return length = 189;
    } else if (a.length >= 294 && a.length < 315) {
      return length = 203;
    } else if (a.length >= 315 && a.length < 336) {
      return length = 217;
    } else if (a.length >= 336 && a.length < 357) {
      return length = 231;
    } else if (a.length >= 357 && a.length < 378) {
      return length = 245;
    }

    return length;
  }

  @override
  Widget build(BuildContext context) {
    List diemdanh = checkInList;
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
              "Day": DateTime.now().day,
              "Month": DateTime.now().month,
              "Year": DateTime.now().year,
              "Coin": 100,
            }).then((value) {
              EasyLoading.dismiss();
              setState(() {
                checkInModel.getCheckInList().then((value) => setState(() {
                      checkInList = value.toList();
                    }));
              });
              diemdanh = checkInList;
              widget.save();
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
      } else if (diemdanh[diemdanh.length - 1]["Year"] == DateTime.now().year &&
          diemdanh[diemdanh.length - 1]["Month"] == DateTime.now().month &&
          diemdanh[diemdanh.length - 1]["Day"] == DateTime.now().day) {
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
      } else {
        EasyLoading.show(status: "Đang xử lý");
        Future.delayed(const Duration(seconds: 1), () {
          checkInModel.addCheckIn({
            "Day": DateTime.now().day,
            "Month": DateTime.now().month,
            "Year": DateTime.now().year,
            "Coin": 100,
          }).then((value) {
            EasyLoading.dismiss();
            setState(() {
              checkInModel.getCheckInList().then((value) => setState(() {
                    checkInList = value.toList();
                  }));
            });
            diemdanh = checkInList;
            widget.save();
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Điểm danh",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              // GestureDetector(
              //   onTap: () => Navigator.of(context).pop(),
              //   child: Container(
              //     child: Icon(Icons.close),
              //   ),
              // )
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Container(
                    height: showMore == true ? 320 : 75,
                    child: ListView(
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
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  7 -
                                              14,
                                          margin:
                                              const EdgeInsets.only(bottom: 2),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                              color:
                                                  index + 1 <= diemdanh.length
                                                      ? Colors.black
                                                          .withOpacity(0.2)
                                                      : Colors.white,
                                              border:
                                                  Border.all(color: mainColor),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4))),
                                          child: Column(
                                            children: [
                                              Text(
                                                "100",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: mainColor),
                                              ),
                                              index + 1 <= diemdanh.length
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: mainColor,
                                                      size: 20,
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
                                              color: mainColor),
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
                                    checkLength(diemdanh),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: index + 1 + 7 <=
                                                            diemdanh.length
                                                        ? Colors.black
                                                            .withOpacity(0.2)
                                                        : Colors.white,
                                                    border: Border.all(
                                                        color: mainColor),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "100",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: mainColor),
                                                    ),
                                                    index + 1 + 7 <=
                                                            diemdanh.length
                                                        ? Icon(
                                                            Icons.check_circle,
                                                            size: 20,
                                                            color: mainColor,
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
                                                    color: mainColor),
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
                    )),
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
