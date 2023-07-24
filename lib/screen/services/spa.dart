import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/services/modal_dia_chi_booking.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class SpaScreen extends StatefulWidget {
  const SpaScreen({super.key});

  @override
  State<SpaScreen> createState() => _SpaScreenState();
}

class _SpaScreenState extends State<SpaScreen> {
  LocalStorage storage = LocalStorage('auth');
  LocalStorage storageToken = LocalStorage('token');
  LocalStorage storageCN = LocalStorage("chi_nhanh");
  @override
  initState() {
    super.initState();
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void save() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map chiNhanh = jsonDecode(storageCN.getItem("chi_nhanh"));
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: MyBottomMenu(
              active: 0,
              save: () => setState(() {}),
            ),
            appBar: AppBar(
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
              title: const Text("Spa",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            drawer: const MyLeftMenu(),
            body: RefreshIndicator(
              onRefresh: () => refreshData(),
              child: SingleChildScrollView(
                // reverse: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
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
                                                      if (storage.getItem(
                                                              "phone") !=
                                                          null) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BookingServices(
                                                                          dichvudachon:
                                                                              item,
                                                                        )));
                                                      } else {
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
                                                            builder:
                                                                (BuildContext
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
                                                                    ModalPassExist(
                                                                        save:
                                                                            save),
                                                              );
                                                            });
                                                      }
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
                                                      if (storage.getItem(
                                                              "phone") !=
                                                          null) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BookingServices(
                                                                          dichvudachon:
                                                                              item,
                                                                        )));
                                                      } else {
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
                                                            builder:
                                                                (BuildContext
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
                                                                    ModalPassExist(
                                                                        save:
                                                                            save),
                                                              );
                                                            });
                                                      }
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
                                                      if (storage.getItem(
                                                              "phone") !=
                                                          null) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BookingServices(
                                                                          dichvudachon:
                                                                              item,
                                                                        )));
                                                      } else {
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
                                                            builder:
                                                                (BuildContext
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
                                                                    ModalPassExist(
                                                                        save:
                                                                            save),
                                                              );
                                                            });
                                                      }
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
                ),
              ),
            )));
  }
}
