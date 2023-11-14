import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class SpecialServiceScreen extends StatefulWidget {
  const SpecialServiceScreen({super.key});

  @override
  State<SpecialServiceScreen> createState() => _SpecialServiceScreenState();
}

bool isLoading = false;
String showIndex = "";

class _SpecialServiceScreenState extends State<SpecialServiceScreen> {
  final ServicesModel servicesModel = ServicesModel();

  final LocalStorage storageToken = LocalStorage("customer_token");
  @override
  initState() {
    super.initState();
    setState(() {
      showIndex = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    showIndex = "";
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(active: 0),
            appBar: AppBar(
              primary: false,
              elevation: 0.0,
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
              title: const Text("Dịch vụ nổi bật",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: FutureBuilder(
              future: servicesModel.getHotServices(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      children: [
                        Wrap(
                            runSpacing: 15,
                            alignment: WrapAlignment.spaceBetween,
                            children: list.map((item) {
                              return GestureDetector(
                                  onTap: () => setState(() {
                                        showIndex = item["Code"];
                                      }),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                22.5,
                                        height: 230,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0, 1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: isLoading
                                            ? const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: LoadingIndicator(
                                                      colors:
                                                          kDefaultRainbowColors,
                                                      indicatorType: Indicator
                                                          .lineSpinFadeLoader,
                                                      strokeWidth: 1,
                                                      // pathBackgroundColor: Colors.black45,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(15),
                                                        child: Image.network(
                                                          "${item["Image_Name"] ?? "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                                          fit: BoxFit.cover,
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width,
                                                          height: 120,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "${item["Name"]}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: mainColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                    ],
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(8)),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: Offset(0, 1), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            showIndex =
                                                            item["Code"];
                                                          });
                                                        },
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          padding: EdgeInsets.symmetric(vertical: 8),
                                                          decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.all(
                                                                Radius.circular(8)),
                                                            color: mainColor,
                                                          ),
                                                          child: Text("Xem thêm",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.amber)),
                                                        )),
                                                  )
                                                ],
                                              ),
                                      ),
                                      if (showIndex.isNotEmpty &&
                                          showIndex == item["Code"])
                                        Positioned.fill(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(15)),
                                                    color: Colors.black
                                                        .withOpacity(0.4)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            showIndex = "";
                                                          });
                                                          showModalBottomSheet<
                                                                  void>(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              clipBehavior: Clip
                                                                  .antiAliasWithSaveLayer,
                                                              context: context,
                                                              isScrollControlled:
                                                                  true,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Container(
                                                                    padding: EdgeInsets.only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom),
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.85,
                                                                    child:
                                                                        ChiTietScreen(
                                                                      detail:
                                                                          item,
                                                                    ));
                                                              });
                                                        },
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 6,
                                                                    horizontal:
                                                                        10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .blue[500],
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          4)),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    "assets/images/eye-white.png",
                                                                    width: 24,
                                                                    height: 24),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                const Text(
                                                                  "Xem chi tiết",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                )
                                                              ],
                                                            ))),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            showIndex = "";
                                                          });
                                                          if (storageToken.getItem(
                                                                  "customer_token") ==
                                                              null) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const LoginScreen()));
                                                          } else {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            BookingServices(
                                                                              dichvudachon: item,
                                                                            )));
                                                          }
                                                        },
                                                        child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 6,
                                                                    horizontal:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            4)),
                                                                color: Colors
                                                                    .blue[900]),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    "assets/images/calendar-solid-white.png",
                                                                    width: 24,
                                                                    height: 24),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                const Text(
                                                                  "Đặt lịch",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                )
                                                              ],
                                                            )))
                                                  ],
                                                )))
                                    ],
                                  ));
                            }).toList())
                      ]);
                } else {
                  return const Center(
                    child: Row(
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
                    ),
                  );
                }
              },
            )));
  }
}
