import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/services/modal_dia_chi_booking.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class AllServiceScreen extends StatefulWidget {
  const AllServiceScreen({super.key});

  @override
  State<AllServiceScreen> createState() => _AllServiceScreenState();
}

int? _selectedIndex;

class _AllServiceScreenState extends State<AllServiceScreen>
    with TickerProviderStateMixin {
  LocalStorage storage = LocalStorage('auth');
  LocalStorage storageToken = LocalStorage('token');
  LocalStorage storageCN = LocalStorage("chi_nhanh");
  TabController? tabController;
  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map chiNhanh = jsonDecode(storageCN.getItem("chi_nhanh"));
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: MyBottomMenu(active: 0, save: refreshData),
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
        title: const Text("Dịch vụ",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
      ),
      drawer: const MyLeftMenu(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.3)),
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: "LexendDeca"),
              onTap: (tabIndex) {
                setState(() {
                  _selectedIndex = tabIndex;
                });
              },
              tabs: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 70,
                  child: Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Home/Services/phun-xam.png",
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Phun xăm",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 70,
                  child: Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Home/Services/lam-dep-da.png",
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Chăm sóc da",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 70,
                  child: Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Home/Services/spa.png",
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Spa",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height - 285,
              child: TabBarView(
                controller: tabController,
                children: [
                  ListView(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: const Text(
                          "Phun xăm mày",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("647569c2706fa019e6720bd4"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 180,
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data!.map((item) {
                                  int index = snapshot.data!.indexOf(item);
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                          backgroundColor: Colors.white,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.95,
                                                child: ChiTietScreen(
                                                  detail: item,
                                                ));
                                          });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: index != 0 ? 15 : 0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                40,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              child: Image.network(
                                                "$apiUrl${item["picture"]}?$token",
                                                height: 130,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${item["ten_vt"]}",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: const Text(
                          "Phun mí mắt",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("647569cb706fa019e6720bee"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 180,
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data!.map((item) {
                                  int index = snapshot.data!.indexOf(item);
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                          backgroundColor: Colors.white,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.95,
                                                child: ChiTietScreen(
                                                  detail: item,
                                                ));
                                          });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: index != 0 ? 15 : 0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                40,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              child: Image.network(
                                                "$apiUrl${item["picture"]}?$token",
                                                height: 130,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${item["ten_vt"]}",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: const Text(
                          "Phun xăm môi",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("647569d6706fa019e6720c08"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 180,
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data!.map((item) {
                                  int index = snapshot.data!.indexOf(item);
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                          backgroundColor: Colors.white,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.95,
                                                child: ChiTietScreen(
                                                  detail: item,
                                                ));
                                          });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: index != 0 ? 15 : 0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                40,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              child: Image.network(
                                                "$apiUrl${item["picture"]}?$token",
                                                height: 130,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${item["ten_vt"]}",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 20),
                        child: const Text(
                          "Xóa, sửa lại",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("64756a1c706fa019e6720c22"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 180,
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data!.map((item) {
                                  int index = snapshot.data!.indexOf(item);
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                          backgroundColor: Colors.white,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.95,
                                                child: ChiTietScreen(
                                                  detail: item,
                                                ));
                                          });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: index != 0 ? 15 : 0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                40,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              child: Image.network(
                                                "$apiUrl${item["picture"]}?$token",
                                                height: 130,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${item["ten_vt"]}",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      FutureBuilder(
                        future: callServiceApi("64756979706fa019e6720b5d"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data!.map((item) {
                                int index = snapshot.data!.indexOf(item);
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: index != 0 ? 15 : 0),
                                  decoration: BoxDecoration(
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
                                  height: 140,
                                  child: TextButton(
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                          backgroundColor: Colors.white,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.95,
                                                child: ChiTietScreen(
                                                  detail: item,
                                                ));
                                          });
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image.network(
                                            "$apiUrl${item["picture"]}?$token",
                                            width: 110,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Wrap(
                                              children: [
                                                Text(
                                                  item["ten_vt"],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Html(style: {
                                                      "*": Style(
                                                          fontSize:
                                                              FontSize(12),
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          maxLines: 2,
                                                          margin:
                                                              Margins.all(0),
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis)
                                                    }, data: item["mieu_ta"])),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (storage.getItem(
                                                                "phone") !=
                                                            null &&
                                                        storageToken.getItem(
                                                                "token") !=
                                                            null) {
                                                      showModalBottomSheet<
                                                              void>(
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          context: context,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      15.0),
                                                            ),
                                                          ),
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                                padding: EdgeInsets.only(
                                                                    bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .8,
                                                                child:
                                                                    ModalDiaChiBooking(
                                                                  activeService:
                                                                      item[
                                                                          "ten_vt"],
                                                                ));
                                                          });
                                                    } else if (storage.getItem(
                                                                "phone") ==
                                                            null &&
                                                        storageToken.getItem(
                                                                "token") !=
                                                            null) {
                                                      showModalBottomSheet<
                                                              void>(
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              padding: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.96,
                                                              child:
                                                                  const ModalPassExist(),
                                                            );
                                                          });
                                                    } else {
                                                      showModalBottomSheet<
                                                              void>(
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              padding: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.96,
                                                              child:
                                                                  const ModalPhone(),
                                                            );
                                                          });
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              4,
                                                              4), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          6)),
                                                              color: Colors
                                                                  .red[200]),
                                                          child: Image.asset(
                                                            "assets/images/calendar-black.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                        const Text(
                                                          "Đặt lịch",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    makingPhoneCall(
                                                        chiNhanh["exfields"]
                                                            ["dien_thoai"]);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              4,
                                                              4), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            6)),
                                                                color: Colors
                                                                    .red[200]),
                                                            child: Image.asset(
                                                              "assets/images/call-black.png",
                                                              width: 20,
                                                              height: 20,
                                                            )),
                                                        const Text(
                                                          "Tư vấn",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 20),
                        child: const Text(
                          "Tắm trắng",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("64756b65706fa019e6720d91"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data!.map((item) {
                                int index = snapshot.data!.indexOf(item);
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: index != 0 ? 15 : 0),
                                  decoration: BoxDecoration(
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
                                  height: 270,
                                  child: TextButton(
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                            backgroundColor: Colors.white,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.95,
                                                  child: ChiTietScreen(
                                                    detail: item,
                                                  ));
                                            });
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius
                                                        .vertical(
                                                    top: Radius.circular(10)),
                                                child: Image.network(
                                                  "$apiUrl${item["picture"]}?$token",
                                                  height: 163,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item["ten_vt"],
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5, bottom: 5),
                                                        child: Html(
                                                            style: {
                                                              "*": Style(
                                                                  fontSize:
                                                                      FontSize(
                                                                          12),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  maxLines: 2,
                                                                  margin: Margins
                                                                      .all(0),
                                                                  textOverflow:
                                                                      TextOverflow
                                                                          .ellipsis)
                                                            },
                                                            data: item[
                                                                "mieu_ta"])),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                          Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet<
                                                              void>(
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          context: context,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      15.0),
                                                            ),
                                                          ),
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                                padding: EdgeInsets.only(
                                                                    bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .8,
                                                                child:
                                                                    ModalDiaChiBooking(
                                                                  activeService:
                                                                      item[
                                                                          "ten_vt"],
                                                                ));
                                                          });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 8,
                                                            offset: const Offset(
                                                                4,
                                                                4), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            6)),
                                                                color: Colors
                                                                    .red[200]),
                                                            child: Image.asset(
                                                              "assets/images/calendar-black.png",
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                          ),
                                                          const Text(
                                                            "Đặt lịch",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      makingPhoneCall(
                                                          chiNhanh["exfields"]
                                                              ["dien_thoai"]);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 8,
                                                            offset: const Offset(
                                                                4,
                                                                4), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 5),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              6)),
                                                                  color: Colors
                                                                      .red[200]),
                                                              child: Image.asset(
                                                                "assets/images/call-black.png",
                                                                width: 20,
                                                                height: 20,
                                                              )),
                                                          const Text(
                                                            "Tư vấn",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ))
                                        ],
                                      )),
                                );
                              }).toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, top: 40, bottom: 20),
                        child: const Text(
                          "Triệt lông",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("64756b31706fa019e6720d5d"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data!.map((item) {
                                int index = snapshot.data!.indexOf(item);
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: index != 0 ? 15 : 0),
                                  decoration: BoxDecoration(
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
                                  height: 270,
                                  child: TextButton(
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                            backgroundColor: Colors.white,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.95,
                                                  child: ChiTietScreen(
                                                    detail: item,
                                                  ));
                                            });
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius
                                                        .vertical(
                                                    top: Radius.circular(10)),
                                                child: Image.network(
                                                  "$apiUrl${item["picture"]}?$token",
                                                  height: 163,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item["ten_vt"],
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5, bottom: 5),
                                                        child: Html(
                                                            style: {
                                                              "*": Style(
                                                                  fontSize:
                                                                      FontSize(
                                                                          12),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  maxLines: 2,
                                                                  margin: Margins
                                                                      .all(0),
                                                                  textOverflow:
                                                                      TextOverflow
                                                                          .ellipsis)
                                                            },
                                                            data: item[
                                                                "mieu_ta"])),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                          Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet<
                                                              void>(
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          context: context,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      15.0),
                                                            ),
                                                          ),
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                                padding: EdgeInsets.only(
                                                                    bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .8,
                                                                child:
                                                                    ModalDiaChiBooking(
                                                                  activeService:
                                                                      item[
                                                                          "ten_vt"],
                                                                ));
                                                          });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 8,
                                                            offset: const Offset(
                                                                4,
                                                                4), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            6)),
                                                                color: Colors
                                                                    .red[200]),
                                                            child: Image.asset(
                                                              "assets/images/calendar-black.png",
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                          ),
                                                          const Text(
                                                            "Đặt lịch",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      makingPhoneCall(
                                                          chiNhanh["exfields"]
                                                              ["dien_thoai"]);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 8,
                                                            offset: const Offset(
                                                                4,
                                                                4), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 5),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              6)),
                                                                  color: Colors
                                                                      .red[200]),
                                                              child: Image.asset(
                                                                "assets/images/call-black.png",
                                                                width: 20,
                                                                height: 20,
                                                              )),
                                                          const Text(
                                                            "Tư vấn",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ))
                                        ],
                                      )),
                                );
                              }).toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 20),
                        child: const Text(
                          "Giảm béo",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("64756b56706fa019e6720d77"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data!.map((item) {
                                int index = snapshot.data!.indexOf(item);
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: index != 0 ? 15 : 0),
                                  decoration: BoxDecoration(
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
                                  height: 270,
                                  child: TextButton(
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                            backgroundColor: Colors.white,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.95,
                                                  child: ChiTietScreen(
                                                    detail: item,
                                                  ));
                                            });
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius
                                                        .vertical(
                                                    top: Radius.circular(10)),
                                                child: Image.network(
                                                  "$apiUrl${item["picture"]}?$token",
                                                  height: 163,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item["ten_vt"],
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5, bottom: 5),
                                                        child: Html(
                                                            style: {
                                                              "*": Style(
                                                                  fontSize:
                                                                      FontSize(
                                                                          12),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  maxLines: 2,
                                                                  margin: Margins
                                                                      .all(0),
                                                                  textOverflow:
                                                                      TextOverflow
                                                                          .ellipsis)
                                                            },
                                                            data: item[
                                                                "mieu_ta"])),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                          Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet<
                                                              void>(
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          context: context,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      15.0),
                                                            ),
                                                          ),
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                                padding: EdgeInsets.only(
                                                                    bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .8,
                                                                child:
                                                                    ModalDiaChiBooking(
                                                                  activeService:
                                                                      item[
                                                                          "ten_vt"],
                                                                ));
                                                          });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 8,
                                                            offset: const Offset(
                                                                4,
                                                                4), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            6)),
                                                                color: Colors
                                                                    .red[200]),
                                                            child: Image.asset(
                                                              "assets/images/calendar-black.png",
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                          ),
                                                          const Text(
                                                            "Đặt lịch",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      makingPhoneCall(
                                                          chiNhanh["exfields"]
                                                              ["dien_thoai"]);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 8,
                                                            offset: const Offset(
                                                                4,
                                                                4), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 5),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              6)),
                                                                  color: Colors
                                                                      .red[200]),
                                                              child: Image.asset(
                                                                "assets/images/call-black.png",
                                                                width: 20,
                                                                height: 20,
                                                              )),
                                                          const Text(
                                                            "Tư vấn",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ))
                                        ],
                                      )),
                                );
                              }).toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ))
        ],
      ),
    ));
  }
}
