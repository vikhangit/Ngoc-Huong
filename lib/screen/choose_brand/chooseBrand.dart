import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
// import 'package:localstorage/localstorage.dart';

class ChooseBrandScreen extends StatefulWidget {
  const ChooseBrandScreen({super.key});

  @override
  State<ChooseBrandScreen> createState() => _ChooseBrandScreenState();
}

String valueSearch = "";
Map activeCN = {};

class _ChooseBrandScreenState extends State<ChooseBrandScreen> {
  LocalStorage storage = LocalStorage('chi_nhanh');
  late TextEditingController controller;
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
  void initState() {
    controller = TextEditingController(text: valueSearch);
    Future.delayed(const Duration(seconds: 3), () {});
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        primary: false,
        elevation: 0.0,
        leadingWidth: 45,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Chọn chi nhánh",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
      ),
      floatingActionButton: activeCN.isEmpty
          ? Container()
          : Container(
              margin: const EdgeInsets.only(top: 20),
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: TextButton(
                  onPressed: () {
                    storage.setItem("chi_nhanh", jsonEncode(activeCN));
                    Navigator.pushNamed(context, "home");
                  },
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0.0))),
                  child: const Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                  )),
            ),
      body: Container(
        padding: const EdgeInsets.only(top: 15.0, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 20, left: 15, right: 15),
              child: const Text(
                "Hãy chọn chi nhánh gần bạn nhất để có thể trải nghiệm nhiều dịch vụ chất lượng cao của Ngọc Hường",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(top: 15, bottom: 20),
            //   child: TextField(
            //     textAlignVertical: TextAlignVertical.center,
            //     autofocus: false,
            //     style: const TextStyle(
            //         fontSize: 15,
            //         color: Colors.black,
            //         fontWeight: FontWeight.w500),
            //     onChanged: (value) {
            //       setState(() {
            //         valueSearch = value;
            //       });
            //     },
            //     controller: controller,
            //     decoration: InputDecoration(
            //       prefixIcon: const Icon(
            //         Icons.search_outlined,
            //         size: 30,
            //         color: Colors.black,
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: const BorderRadius.all(Radius.circular(10)),
            //         borderSide: BorderSide(
            //             width: 1,
            //             color: Theme.of(context)
            //                 .colorScheme
            //                 .primary), //<-- SEE HERE
            //       ),
            //       enabledBorder: const OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(10)),
            //         borderSide:
            //             BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
            //       ),
            //       contentPadding:
            //           const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            //       hintStyle: const TextStyle(
            //           fontSize: 15,
            //           color: Colors.black,
            //           fontWeight: FontWeight.w300),
            //       hintText: 'Nhập để tìm kiếm',
            //     ),
            //   ),
            // ),

            FutureBuilder(
              future: callChiNhanhApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: snapshot.data!.map((item) {
                          int index = snapshot.data!.indexOf(item);
                          if (item["ten_kho"]
                              .toString()
                              .toLowerCase()
                              .contains(valueSearch.toLowerCase())) {
                            return Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                          activeCN = item;
                                        });
                                      },
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.only(
                                                  top: 0,
                                                  left: 0,
                                                  right: 0,
                                                  bottom: 10))),
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
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${item["ten_kho"]}",
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
                                                        "${item["exfields"]["dia_chi"]}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    makingPhoneCall(
                                                        item["exfields"]
                                                            ["dien_thoai"]);
                                                  },
                                                  child: Row(
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
                                                          "Hotline: ${item["exfields"]["dien_thoai"]}",
                                                          style:
                                                              const TextStyle(
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
                                                              "https://www.google.com/maps/search/${"Thẩm+Mỹ+Viện+Ngọc+Hường+${item["ten_kho"] == "An Giang" || item["ten_kho"] == "Bình Dương" ? item["exfields"]["dia_chi"].toString().replaceAll(" ", "+") : item["ten_kho"].toString().replaceAll(" ", "+")}"}/@${item["location"]["latitude"]},${item["location"]["longitude"]}");
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
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xFF1CC473)),
                                                            ),
                                                          ],
                                                        )),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: checkStatusBrand(
                                                                  "${item["time_close"]}")[
                                                              "color"]),
                                                      child: Text(
                                                          "${checkStatusBrand("${item["time_close"]}")["text"]}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          )),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (activeCN["ma_kho"] == item["ma_kho"])
                                      Positioned.fill(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                          borderRadius: const BorderRadius.all(
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
                          } else {
                            return Container();
                          }
                        }).toList()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
}
