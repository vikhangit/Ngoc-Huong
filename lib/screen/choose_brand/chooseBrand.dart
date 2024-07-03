import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/branchsModel.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/choose_brand/selectCity.dart';
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
String provinceId = "";
String activeCity = "";

class _ChooseBrandScreenState extends State<ChooseBrandScreen> {
  TextEditingController cityController = TextEditingController();
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
    cityController = TextEditingController(text: activeCity);
    setState(() {
      provinceId = "";
      activeCity = "";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    provinceId = "";
    activeCity = "";
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
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
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        margin: const EdgeInsets.only(
                            top: 15, left: 15, right: 15, bottom: 15),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          readOnly: true,
                          controller: TextEditingController(text: activeCity),
                          onTap: () {
                            showModalBottomSheet<void>(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.0),
                                  ),
                                ),
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
                                              0.8,
                                      child: SelectCity(
                                        saveAddress: () {
                                          setState(() {});
                                        },
                                      ));
                                });
                          },
                          decoration: InputDecoration(
                              hintText: "Chọn tỉnh thành",
                              hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey.shade700,
                                size: 32,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade700,
                                size: 32,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: model.getBranchs(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List newList = snapshot.data!
                                  .where((item) =>
                                      item["Address"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(activeCity
                                              .replaceAll("Tỉnh", "")
                                              .replaceAll("Thành Phố", "")
                                              .toLowerCase()) ||
                                      item["Name"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(activeCity
                                              .replaceAll("Tỉnh", "")
                                              .replaceAll("Thành Phố", "")
                                              .toLowerCase()))
                                  .toList();
                              return newList.isEmpty
                                  ? activeCity.isNotEmpty
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            "Hiện tại ở $activeCity chưa có chi nhánh của Ngọc Hường",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: const Text(
                                              "Hiện tại ở hệ thống quản trị của Ngọc Hường đang bảo trì. Xin quý khachs vui lòng thử lại sau"))
                                  : ListView(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      children: newList.map((item) {
                                        int index =
                                            snapshot.data!.indexOf(item);
                                        if (item["Name"] == "Kho miền bắc") {
                                          return Container();
                                        } else {
                                          return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 2)),
                                              margin: EdgeInsets.only(
                                                  // left: 10,
                                                  // right: 10,
                                                  top: index == 0 ? 0 : 25),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 15),
                                              // height: 50,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // ClipRRect(
                                                      //   borderRadius:
                                                      //       const BorderRadius
                                                      //           .all(
                                                      //           Radius.circular(
                                                      //               10)),
                                                      //   child: Image.network(
                                                      //     item["ImageName"],
                                                      //     width: MediaQuery.of(
                                                      //             context)
                                                      //         .size
                                                      //         .width,
                                                      //     fit: BoxFit.fitHeight,
                                                      //     errorBuilder: (context,
                                                      //         exception,
                                                      //         stackTrace) {
                                                      //       return Image.network(
                                                      //           fit: BoxFit.cover,
                                                      //           width:
                                                      //               MediaQuery.of(
                                                      //                       context)
                                                      //                   .size
                                                      //                   .width,
                                                      //           'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
                                                      //     },
                                                      //   ),
                                                      // ),
                                                      // const SizedBox(
                                                      //   height: 15,
                                                      // ),
                                                      // Container(
                                                      //   alignment:
                                                      //       Alignment.center,
                                                      //   width: 24,
                                                      //   height: 24,
                                                      //   decoration: BoxDecoration(

                                                      //       border: Border.all(
                                                      //           width: 1,
                                                      //          ),
                                                      //       borderRadius:
                                                      //           const BorderRadius
                                                      //               .all(Radius
                                                      //                   .circular(
                                                      //                       8))),
                                                      //   child: GestureDetector(
                                                      //       onTap: () {
                                                      //         setState(() {});
                                                      //       },
                                                      //       child: Icon(
                                                      //         Icons.check,
                                                      //         color: Colors.white,
                                                      //         size: 18,
                                                      //       )),
                                                      // ),

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
                                                                  child: Image
                                                                      .asset(
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
                                                            GestureDetector(
                                                              onTap: () {
                                                                launchInBrowser(
                                                                    "tel:${item["Hotline"]}");
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 6,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/call-black.png",
                                                                      width: 20,
                                                                      height:
                                                                          20,
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
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 6,
                                                                  child: Image
                                                                      .asset(
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
                                                                          color:
                                                                              Color(0xFF1CC473),
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
                                                                              fontSize: 14,
                                                                              color: Color(0xFF1CC473)),
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
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (activeBranch
                                                                        .isEmpty) {
                                                                      setState(
                                                                          () {
                                                                        activeBranch =
                                                                            item;
                                                                      });
                                                                    } else {
                                                                      if (activeBranch[
                                                                              "Code"] ==
                                                                          item[
                                                                              "Code"]) {
                                                                        setState(
                                                                            () {
                                                                          activeBranch =
                                                                              {};
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          activeBranch =
                                                                              item;
                                                                        });
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            2,
                                                                        horizontal:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        color: activeBranch.isNotEmpty && activeBranch["Code"] == item["Code"]
                                                                            ? Colors
                                                                                .black
                                                                            : Colors
                                                                                .indigo.shade400,
                                                                        borderRadius: const BorderRadius
                                                                            .all(
                                                                            Radius.circular(15))),
                                                                    child: Text(
                                                                      activeBranch.isNotEmpty &&
                                                                              activeBranch["Code"] == item["Code"]
                                                                          ? "Hủy Chọn Chi Nhánh"
                                                                          : "Chọn Chi Nhánh",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                  // Positioned.fill(
                                                  //     child: Container(
                                                  //   decoration: BoxDecoration(
                                                  //     color: Colors.black
                                                  //         .withOpacity(0.4),
                                                  //     borderRadius:
                                                  //         const BorderRadius
                                                  //             .all(
                                                  //             Radius.circular(
                                                  //                 10)),
                                                  //   ),
                                                  //   child: Material(
                                                  //     elevation: 0,
                                                  //     color: Colors.black
                                                  //         .withOpacity(0.4),
                                                  //     child: const Center(
                                                  //       child: Icon(
                                                  //         Icons
                                                  //             .check_circle_outline,
                                                  //         color: Colors.white,
                                                  //         size: 50,
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ))
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
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey.shade300, width: 2))),
                          child: Column(
                            children: [
                              if (activeBranch.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        child: Text(
                                      "Đã chọn",
                                      textAlign: TextAlign.left,
                                    )),
                                    Expanded(
                                        child: Text(
                                      "${activeBranch["Name"]}",
                                      textAlign: TextAlign.right,
                                    ))
                                  ],
                                ),
                              activeBranch.isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 50,
                                      child: TextButton(
                                        style: ButtonStyle(
                                            shape: WidgetStateProperty.all(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)))),
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                            padding: WidgetStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 20))),
                                        onPressed: () {
                                          storageBranch.setItem("branch",
                                              jsonEncode(activeBranch));
                                          widget.saveCN();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BookingServices()));
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1, child: Container()),
                                            const Expanded(
                                              flex: 8,
                                              child: Center(
                                                child: Text(
                                                  "Tiếp tục",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                      margin: EdgeInsets.only(top: 10),
                                      height: 50,
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
                    ],
                  )),
            )));
  }
}
