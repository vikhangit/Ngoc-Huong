import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/branchsModel.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
// import 'package:localstorage/localstorage.dart';

class ChooseBrandScreen extends StatefulWidget {
  final Function saveCN;
  const ChooseBrandScreen({super.key, required this.saveCN});

  @override
  State<ChooseBrandScreen> createState() => _ChooseBrandScreenState();
}

Map activeBranch = {};

class _ChooseBrandScreenState extends State<ChooseBrandScreen> {
  final LocalStorage storageBranch = LocalStorage('branch');
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  final BranchsModel model = BranchsModel();
  DateTime getPSTTime(DateTime now) {
    tz.initializeTimeZones();
    final pacificTimeZone = tz.getLocation('Asia/Ho_Chi_Minh');

    return tz.TZDateTime.from(now, pacificTimeZone);
  }

  Future<void> launchInBrowser(String link) async {
    Uri url = Uri.parse(link);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // Map checkStatusBrand(String timeClose) {
  //   DateTime now = DateTime.now();
  //   DateTime checkTime = getPSTTime(DateTime.parse(timeClose));
  //   if (checkTime.isAfter(now)) {
  //     return {"text": "Close", "color": Theme.of(context).colorScheme.primary};
  //   } else {
  //     return {"text": "Open", "color": const Color(0xFF1CC473)};
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {});
    Upgrader.clearSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      bottom: false, top: false,
        child: Scaffold(
            backgroundColor: Colors.white,
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
              title: const Text("Tìm chi nhánh",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: Container(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FutureBuilder(
                          future: model.getBranchs(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  children: snapshot.data!.map((item) {
                                    int index = snapshot.data!.indexOf(item);
                                    if (item["Name"] == "Kho miền bắc") {
                                      return Container();
                                    } else {
                                      return Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          margin: EdgeInsets.only(
                                              // left: 10,
                                              // right: 10,
                                              top: index == 0 ? 0 : 25),
                                          // height: 50,
                                          child: Stack(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    activeBranch = item;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom:
                                                                        10))),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Image.network(
                                                        item["ImageName"],
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        fit: BoxFit.fitHeight,
                                                        errorBuilder: (context,
                                                            exception,
                                                            stackTrace) {
                                                          return Image.network(
                                                              fit: BoxFit.cover,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${item["Name"]}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 6,
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/account/dia-chi.png",
                                                                  width: 25,
                                                                  height: 25,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      Container()),
                                                              Expanded(
                                                                flex: 90,
                                                                child: Text(
                                                                  "${item["Address"]}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 6,
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/call-black.png",
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      Container()),
                                                              Expanded(
                                                                flex: 90,
                                                                child: Text(
                                                                  "Hotline: ${item["Hotline"]}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 6,
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/TimeCircleBlack.png",
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      Container()),
                                                              Expanded(
                                                                flex: 90,
                                                                child: Text(
                                                                  "${item["TimeOut"]} - ${item["TimeClose"]}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    launchInBrowser(
                                                                        item[
                                                                            "LinkGoogleMap"]);
                                                                  },
                                                                  child:
                                                                      const Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .subdirectory_arrow_right,
                                                                        color: Color(
                                                                            0xFF1CC473),
                                                                        size:
                                                                            24,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            3,
                                                                      ),
                                                                      Text(
                                                                        "Xem vị trí",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Color(0xFF1CC473)),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              // Container(
                                                              //   padding: const EdgeInsets
                                                              //           .symmetric(
                                                              //       horizontal: 10,
                                                              //       vertical: 5),
                                                              //   decoration: BoxDecoration(
                                                              //       borderRadius:
                                                              //           const BorderRadius
                                                              //                   .all(
                                                              //               Radius.circular(
                                                              //                   5)),
                                                              //       color: checkStatusBrand(
                                                              //               "${item["time_close"]}")[
                                                              //           "color"]),
                                                              //   child: Text(
                                                              //       "${checkStatusBrand("${item["time_close"]}")["text"]}",
                                                              //       style: const TextStyle(
                                                              //         fontSize: 15,
                                                              //         color: Colors.white,
                                                              //       )),
                                                              // )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              if (activeBranch.isNotEmpty)
                                                if (activeBranch["Code"] ==
                                                    item["Code"])
                                                  Positioned.fill(
                                                      child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors.white,
                                                        size: 50,
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ));
                                    }
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
                                      indicatorType:
                                          Indicator.lineSpinFadeLoader,
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
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      activeBranch.isNotEmpty
                          ? Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 20))),
                                onPressed: () {
                                  storageBranch.setItem(
                                      "branch", jsonEncode(activeBranch));
                                  widget.saveCN();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BookingServices()));
                                },
                                child: Row(
                                  children: [
                                    Expanded(flex: 1, child: Container()),
                                    const Expanded(
                                      flex: 8,
                                      child: Center(
                                        child: Text(
                                          "Tiếp tục",
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
                                        width: 20,
                                        height: 25,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  color: Colors.grey[400]!),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Container()),
                                  const Expanded(
                                    flex: 8,
                                    child: Center(
                                      child: Text(
                                        "Tiếp tục",
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
                                      width: 20,
                                      height: 25,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                ],
                              ),
                            )
                    ],
                  )),
            )));
  }
}
