import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/mission/MissionScreen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:upgrader/upgrader.dart';

class Mission extends StatefulWidget {
  final Function save;
  const Mission({super.key, required this.save});

  @override
  State<Mission> createState() => _MissionState();
}

bool showMore = false;
List checkInList = [];
Map profile = {};
bool isLoading = false;

class _MissionState extends State<Mission> with TickerProviderStateMixin {
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

    Color checkbg(String r) {
      if (r == "open") {
        return Colors.amber;
      } else if (r == "pending") {
        return Colors.indigo;
      } else {
        return Colors.green.shade200;
      }
    }

    void nhannhiemvu(Map item) {
      EasyLoading.show(status: "Vui lòng chờ...");
      Future.delayed(const Duration(seconds: 2), () {
        checkInModel.collectMission(item["Id"]).then((value) {
          EasyLoading.dismiss();
          widget.save();
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const MissionScreen(
          //               ac: 1,
          //             )));
        });
      });
    }

    void nhanxu(Map item) {
      EasyLoading.show(status: "Vui lòng chờ...");
      Future.delayed(const Duration(seconds: 2), () {
        checkInModel.collectMission(item["Id"]).then((value) {
          EasyLoading.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MissionScreen(
                        ac: 2,
                      )));
        });
      });
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: mainColor),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nhiệm vụ",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          FutureBuilder(
              future: checkInModel.getMission(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!;
                  return list.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: list
                              .sublist(0, list.length >= 2 ? 2 : 1)
                              .map((e) {
                            return GestureDetector(
                                onTap: () {
                                  if (e["Status"].toString().toLowerCase() ==
                                      "open") {
                                    customModal.showAlertDialog(
                                        context,
                                        "error",
                                        "Nhận nhiệm vụ",
                                        "Bạn có chắc chắn nhận nhiệm vụ này",
                                        () {
                                      Navigator.of(context).pop();
                                      nhannhiemvu(e);
                                    }, () => Navigator.pop(context));
                                  }
                                  // else if (e["Status"]
                                  //             .toString()
                                  //             .toLowerCase() ==
                                  //         "success" &&
                                  //     e["IsReceived"] == false) {
                                  //   Navigator.of(context).pop();
                                  //   nhanxu(e);
                                  // }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 5, right: 5),
                                  padding: const EdgeInsets.only(
                                      right: 0, left: 10, top: 0, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 0.5, color: mainColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
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
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 0,
                                                bottom: 3.5,
                                                left: 4,
                                                right: 4),
                                            decoration: BoxDecoration(
                                                color: checkbg(e["Status"]
                                                    .toString()
                                                    .toLowerCase()),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                6))),
                                            child: Text(
                                              e["Status"]
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "open"
                                                  ? "Đang mở"
                                                  : e["Status"]
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "pending"
                                                      ? "Đang làm"
                                                      : "Hoàn thành",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  height: 1,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(e["Name"],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(e["Description"],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/icon/Xu1.png",
                                                  width: 45,
                                                  height: 45,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  "${e["Coin"]}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: mainColor),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      // if (e["Status"]
                                      //         .toString()
                                      //         .toLowerCase() ==
                                      //     "success")
                                      //   Text(
                                      //       e["IsReceived"] == false
                                      //           ? "Nhiệm vụ đã hoàn thành. Hãy ấn vào để nhận xu"
                                      //           : "Đã nhận xu. Bạn hãy vào lịch sử nhận xu để kiểm tra",
                                      //       style: const TextStyle(
                                      //         fontStyle: FontStyle.italic,
                                      //         fontSize: 10,
                                      //         fontWeight: FontWeight.w400,
                                      //       ))
                                    ],
                                  ),
                                ));
                          }).toList(),
                        )
                      : Container(
                          child: Text("Bạn chưa có nhiệm vụ"),
                        );
                } else {
                  return const Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  ));
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => MissionScreen()));
                  },
                  child: Row(
                    children: [
                      Text(
                        "Xem tất cả",
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                            fontWeight: FontWeight.w700),
                      ),
                      Icon(
                        Icons.expand_more_outlined,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8),
                        size: 16,
                        weight: 1,
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
