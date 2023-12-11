import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/branchsModel.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ModalDiaChi extends StatefulWidget {
  final Function saveCN;
  const ModalDiaChi({super.key, required this.saveCN});

  @override
  State<ModalDiaChi> createState() => _ModalDiaChiState();
}

Map activeBranch = {};

class _ModalDiaChiState extends State<ModalDiaChi> {
  final BranchsModel model = BranchsModel();
  final LocalStorage storageBranch = LocalStorage('branch');
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  @override
  void initState() {
    Map active = storageBranch.getItem("branch") != null
        ? jsonDecode(storageBranch.getItem("branch"))
        : {};
    setState(() {
      activeBranch = active;
    });
    super.initState();
  }

  void chooseDiaChi(Map item) {
    setState(() {
      activeBranch = item;
    });
  }

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

  Map checkStatusBrand(String timeClose) {
    DateTime now = DateTime.now();
    DateTime checkTime = getPSTTime(DateTime.parse(timeClose));
    if (checkTime.isAfter(now)) {
      return {"text": "Close", "color": Theme.of(context).colorScheme.primary};
    } else {
      return {"text": "Open", "color": const Color(0xFF1CC473)};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30), top: Radius.circular(0))),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            width: 36,
                            height: 36,
                            child: const Icon(
                              Icons.west,
                              size: 16,
                              color: Colors.black,
                            ),
                          )),
                    ),
                    const Expanded(
                      flex: 84,
                      child: Center(
                        child: Text(
                          "Chọn chi nhánh",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: model.getBranchs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.96 - 150,
                      child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                  margin: const EdgeInsets.only(top: 25),
                                  // height: 50,
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activeBranch = item;
                                          });
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                    "https://image-us.eva.vn/upload/3-2022/images/2022-09-09/picture-9-1662696857-151-width1600height1068.jpg"),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${item["Name"]}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 6,
                                                          child: Image.asset(
                                                            "assets/images/account/dia-chi.png",
                                                            width: 25,
                                                            height: 25,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Container()),
                                                        Expanded(
                                                          flex: 90,
                                                          child: Text(
                                                            "${item["Address"]}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 14,
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
                                                          child: Image.asset(
                                                            "assets/images/call-black.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Container()),
                                                        Expanded(
                                                          flex: 90,
                                                          child: Text(
                                                            "Hotline: ${item["Hotline"]}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 14,
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
                                                          child: Image.asset(
                                                            "assets/images/TimeCircleBlack.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Container()),
                                                        Expanded(
                                                          flex: 90,
                                                          child: Text(
                                                            "${item["TimeOut"]} - ${item["TimeClose"]}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 14,
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
                                                        TextButton(
                                                            style: ButtonStyle(
                                                                padding: MaterialStateProperty.all(
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0))),
                                                            onPressed: () {
                                                              launchInBrowser(item[
                                                                  "LinkGoogleMap"]);
                                                            },
                                                            child: const Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .subdirectory_arrow_right,
                                                                  color: Color(
                                                                      0xFF1CC473),
                                                                  size: 24,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  "Xem vị trí",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color(
                                                                          0xFF1CC473)),
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
                                      ),
                                      if (activeBranch.isNotEmpty)
                                        if (activeBranch["Code"] ==
                                            item["Code"])
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
                            }
                          }).toList()),
                    );
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
                },
              ),
            ],
          ),
          activeBranch.isNotEmpty
              ? Container(
                  height: 50,
                  margin: const EdgeInsets.all(15.0),
                  child: TextButton(
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
                    onPressed: () {
                      storageBranch.setItem("branch", jsonEncode(activeBranch));
                      widget.saveCN();
                      Navigator.pop(context);
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
                  margin: const EdgeInsets.all(15.0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
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
      ),
    );
  }
}
