import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:upgrader/upgrader.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

bool isLoading = false;
bool showMore = false;
List diemdanh = [];

class _CheckInState extends State<CheckIn> with TickerProviderStateMixin {
  final ServicesModel servicesModel = ServicesModel();
  final CheckInModel checkInModel = CheckInModel();
  final ProfileModel profileModel = ProfileModel();
  final LocalStorage storageToken = LocalStorage("customer_token");
  final ScrollController scrollController = ScrollController();
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
          diemdanh = value.toList();
        }));
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
    String convertTime(String date) {
      int day = DateTime.parse(date).day;
      int month = DateTime.parse(date).month;
      int year = DateTime.parse(date).year;

      return "${day < 10 ? "0$day" : "$day"}/${month < 10 ? "0$month" : "$month"}/$year";
    }

    return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: showMore ? 430 : 170,
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
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
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          child: Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                  !isLoading
                      ? Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              height: showMore ? 320 : 70,
                              child: ListView(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    spacing: 9,
                                    children: List.generate(
                                        7,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    insetPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 120,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  index + 1 == 7
                                                                      ? "+20"
                                                                      : "+10",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Colors
                                                                          .amber),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Image.asset(
                                                                  "assets/images/icon/Xu.png",
                                                                  width: 30,
                                                                  height: 30,
                                                                ),
                                                              ],
                                                            ),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .indigo,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(99999))),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 40,
                                                                child:
                                                                    const Text(
                                                                  "Đóng",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                7 -
                                                            14,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 2),
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                        color: index + 1 <=
                                                                diemdanh.length
                                                            ? Colors.black
                                                                .withOpacity(
                                                                    0.2)
                                                            : Colors.white,
                                                        border: Border.all(
                                                            color: index + 1 <=
                                                                    diemdanh
                                                                        .length
                                                                ? Colors.black
                                                                    .withOpacity(
                                                                        0.1)
                                                                : index + 1 == 7
                                                                    ? Colors
                                                                        .amber
                                                                    : Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.3)),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    4))),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          index + 1 == 7
                                                              ? "20"
                                                              : "10",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: index +
                                                                          1 <=
                                                                      diemdanh
                                                                          .length
                                                                  ? Colors.black
                                                                      .withOpacity(
                                                                          0.3)
                                                                  : index + 1 ==
                                                                          7
                                                                      ? Colors
                                                                          .amber
                                                                      : Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary),
                                                        ),
                                                        index + 1 <=
                                                                diemdanh.length
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green,
                                                                size: 20,
                                                              )
                                                            : index + 1 == 7
                                                                ? Image.asset(
                                                                    "assets/images/giftbox.png",
                                                                    width: 20,
                                                                    height: 20,
                                                                  )
                                                                : Image.asset(
                                                                    "assets/images/icon/Xu.png",
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: index + 1 <=
                                                                diemdanh.length
                                                            ? Colors.black
                                                                .withOpacity(
                                                                    0.3)
                                                            : index + 1 == 7
                                                                ? Colors.amber
                                                                : Theme.of(
                                                                        context)
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
                                        margin: EdgeInsets.only(top: 15),
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          spacing: 9,
                                          runSpacing: 15,
                                          children: List.generate(
                                              21,
                                              (index) => GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) => Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 120,
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        index + 1 == 7 ||
                                                                                index + 1 == 14 ||
                                                                                index + 1 == 21
                                                                            ? "+20"
                                                                            : "+10",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                24,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Colors.amber),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Image
                                                                          .asset(
                                                                        "assets/images/icon/Xu.png",
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            30,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: const BoxDecoration(
                                                                          color: Colors
                                                                              .indigo,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(99999))),
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height:
                                                                          40,
                                                                      child:
                                                                          const Text(
                                                                        "Đóng",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  7 -
                                                              14,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 2),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 5),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: index +
                                                                              1 +
                                                                              7 <=
                                                                          diemdanh
                                                                              .length
                                                                      ? Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.2)
                                                                      : Colors
                                                                          .white,
                                                                  border: Border.all(
                                                                      color: index + 1 + 7 <= diemdanh.length
                                                                          ? Colors.black.withOpacity(0.1)
                                                                          : index + 1 == 7 || index + 1 == 14 || index + 1 == 21
                                                                              ? Colors.amber
                                                                              : Colors.black.withOpacity(0.3)),
                                                                  borderRadius: const BorderRadius.all(Radius.circular(4))),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                index + 1 ==
                                                                            7 ||
                                                                        index + 1 ==
                                                                            14 ||
                                                                        index + 1 ==
                                                                            21
                                                                    ? "20"
                                                                    : "10",
                                                                style: TextStyle(
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: index + 1 + 7 <= diemdanh.length
                                                                        ? Colors.black.withOpacity(0.3)
                                                                        : index + 1 == 7 || index + 1 == 14 || index + 1 == 21
                                                                            ? Colors.amber
                                                                            : Theme.of(context).colorScheme.primary),
                                                              ),
                                                              index + 1 + 7 <=
                                                                      diemdanh
                                                                          .length
                                                                  ? const Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .green,
                                                                    )
                                                                  : index + 1 ==
                                                                              7 ||
                                                                          index + 1 ==
                                                                              14
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/images/giftbox.png",
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                        )
                                                                      : index + 1 ==
                                                                              21
                                                                          ? Image
                                                                              .asset(
                                                                              "assets/images/award.png",
                                                                              width: 20,
                                                                              height: 20,
                                                                            )
                                                                          : Image
                                                                              .asset(
                                                                              "assets/images/icon/Xu.png",
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: index +
                                                                          1 +
                                                                          7 <=
                                                                      diemdanh
                                                                          .length
                                                                  ? Colors.black
                                                                      .withOpacity(
                                                                          0.3)
                                                                  : index + 1 == 7 ||
                                                                          index + 1 ==
                                                                              14 ||
                                                                          index + 1 ==
                                                                              21
                                                                      ? Colors
                                                                          .amber
                                                                      : Theme.of(
                                                                              context)
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
                      : Container(
                          height: showMore ? 380 : 120,
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
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
                              Text(
                                "Đang lấy dữ liệu",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: diemdanh.isNotEmpty
                      ? convertTime(diemdanh[0]["record_time"]) !=
                              convertTime(DateTime.now().toIso8601String())
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey
                      : Theme.of(context).colorScheme.primary,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(999999))),
              height: 40,
              width: 150,
              child: FutureBuilder(
                  future: profileModel.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () => {
                          setState(() {
                            if (diemdanh.isEmpty) {
                              EasyLoading.show(status: "Đang xử lý");
                              Future.delayed(const Duration(seconds: 1), () {
                                checkInModel.addCheckIn({
                                  "record_time":
                                      DateTime.now().toIso8601String(),
                                  "device_user_id":
                                      "${snapshot.data!["CustomerName"]}"
                                }).then((value) {
                                  EasyLoading.dismiss();
                                  Navigator.pop(context);
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return const CheckIn();
                                    },
                                  );
                                });
                              });
                            } else if (convertTime(
                                    diemdanh[0]["record_time"]) !=
                                convertTime(DateTime.now().toIso8601String())) {
                              EasyLoading.show(status: "Đang xử lý");
                              Future.delayed(const Duration(seconds: 1), () {
                                checkInModel.addCheckIn({
                                  "record_time":
                                      DateTime.now().toIso8601String(),
                                  "device_user_id":
                                      "${snapshot.data!["CustomerName"]}"
                                }).then((value) {
                                  EasyLoading.dismiss();
                                  Navigator.pop(context);
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return const CheckIn();
                                    },
                                  );
                                });
                              });
                            }
                          })
                        },
                        child: const Text(
                          "Check-in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      );
                    } else {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: LoadingIndicator(
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                          ],
                          indicatorType: Indicator.lineSpinFadeLoader,
                          strokeWidth: 1,
                          // pathBackgroundColor: Colors.black45,
                        ),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
