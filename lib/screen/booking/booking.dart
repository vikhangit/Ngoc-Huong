import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_chi_tiet_booking.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_services.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_dia_chi.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingServices extends StatefulWidget {
  const BookingServices({super.key});

  @override
  State<BookingServices> createState() => _BookingServicesState();
}

String madichvu = "";
List chooseService = [
  {
    "icon": "assets/images/Home/Services/phun-xam.png",
    "title": "Dịch vụ phun xăm",
    "show": false,
    "child": [
      {"title": "Phun xăm mày"},
      {"title": "Phun mí mắt"},
      {"title": "Phun xăm môi"},
      {"title": "Xóa, sửa lại"}
    ]
  },
  {
    "icon": "assets/images/Home/Services/lam-dep-da.png",
    "title": "Dịch vụ làm đẹp da",
    "show": false,
  },
  {
    "icon": "assets/images/Home/Services/spa.png",
    "title": "Dịch vụ spa",
    "show": false,
    "child": [
      {"title": "Tắm trắng"},
      {"title": "Triệt lông"},
      {"title": "Giảm béo"}
    ]
  }
];

class _BookingServicesState extends State<BookingServices> {
  LocalStorage storageAuth = LocalStorage("auth");
  @override
  void initState() {
    setState(() {
      for (var i = 0; i < chooseService.length; i++) {
        chooseService[i]["show"] = false;
      }
      madichvu = "";
      activeCN = {};
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var i = 0; i < chooseService.length; i++) {
      chooseService[i]["show"] = false;
    }
    madichvu = "";
    super.dispose();
  }

  void saveCN() {
    setState(() {});
  }

  void showAlertDialog(BuildContext context, String err) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.pop(context, 'OK'),
    );
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return SizedBox(
            // height: 30,
            width: MediaQuery.of(context).size.width,
            child: Text(
              style: const TextStyle(height: 1.6),
              err,
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void selectedItem(int index) {
    if (activeCN.isEmpty) {
      Widget okButton = TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet<void>(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    height: MediaQuery.of(context).size.height * .8,
                    child: ModalDiaChi(
                      saveCN: saveCN,
                    ),
                  );
                });
          });
      AlertDialog alert = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            return SizedBox(
              // height: 30,
              width: MediaQuery.of(context).size.width,
              child: const Text(
                style: TextStyle(height: 1.6),
                "Bạn chưa chọn chi nhánh muốn đặt dịch vụ",
              ),
            );
          },
        ),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      if (chooseService[index]["child"] == null) {
        showModalBottomSheet<void>(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
            ),
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  height: MediaQuery.of(context).size.height * .8,
                  child: ModalService(
                    id: "64756979706fa019e6720b5d",
                    title: "làm đẹp da",
                    activeCN: activeCN,
                  ));
            });
      } else {
        for (var i = 0; i < chooseService.length; i++) {
          if (index == i) {
            setState(() {
              chooseService[i]["show"] = !chooseService[i]["show"];
            });
          }
        }
      }
    }
  }

  void chooseModal(String name) {
    print(name);
    switch (name) {
      case "Phun xăm mày":
        {
          setState(() {
            madichvu = "647569c2706fa019e6720bd4";
          });
          break;
        }
      case "Phun mí mắt":
        {
          setState(() {
            madichvu = "647569cb706fa019e6720bee";
          });
          break;
        }
      case "Phun xăm môi":
        {
          setState(() {
            madichvu = "647569d6706fa019e6720c08";
          });
          break;
        }
      case "Xóa, sửa lại":
        {
          setState(() {
            madichvu = "64756a1c706fa019e6720c22";
          });
          break;
        }
      case "Làm đẹp da":
        {
          setState(() {
            madichvu = "64756979706fa019e6720b5d";
          });
          break;
        }
      case "Tắm trắng":
        {
          setState(() {
            madichvu = "64756b65706fa019e6720d91";
          });
          break;
        }
      case "Triệt lông":
        {
          setState(() {
            madichvu = "64756b31706fa019e6720d5d";
          });
          break;
        }
      case "Giảm béo":
        {
          setState(() {
            madichvu = "64756b56706fa019e6720d77";
          });
          break;
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    _makingPhoneCall() async {
      var url = Uri.parse("tel:1900123456");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 5,
            // ),

            appBar: AppBar(
                bottomOpacity: 0.0,
                elevation: 0.0,
                leadingWidth: 40,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.west,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("Đặt lịch tại",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.black)),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0),
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  height:
                                      MediaQuery.of(context).size.height * .8,
                                  child: ModalDiaChi(
                                    saveCN: saveCN,
                                  ),
                                );
                              });
                        },
                        child: SizedBox(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.fmd_good_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              activeCN.isNotEmpty
                                  ? FutureBuilder(
                                      future: callChiNhanhApiByCN(
                                          activeCN["ma_kho"]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                              snapshot.data![0]["ten_kho"],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black));
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    )
                                  : const Text("Đặt lịch",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ))
                  ],
                )),
            drawer: const MyLeftMenu(),
            body: Column(
                // reverse: true,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Chọn dịch vụ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              children: chooseService.map((item) {
                                int index = chooseService.indexOf(item);
                                return Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(4,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 28)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top: const Radius
                                                                .circular(10),
                                                            bottom:
                                                                Radius.circular(
                                                                    item["show"] ==
                                                                            false
                                                                        ? 10
                                                                        : 0)))),
                                          ),
                                          onPressed: () {
                                            selectedItem(index);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(children: [
                                                Image.asset(
                                                  item["icon"],
                                                  width: 40,
                                                  height: 40,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  item["title"],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              ]),
                                              item["show"] == false
                                                  ? const Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      color: Colors.black,
                                                      size: 24,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .keyboard_arrow_up_outlined,
                                                      color: Colors.black,
                                                      size: 24,
                                                    )
                                            ],
                                          ),
                                        ),
                                        if (item["show"] == true)
                                          if (item["child"] != null)
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          bottom:
                                                              Radius.circular(
                                                                  10))),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: item["child"]
                                                      .map<Widget>((childItem) {
                                                    return Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              border: Border(
                                                                  bottom:
                                                                      BorderSide(
                                                        color: Colors.grey,
                                                        width: 1,
                                                      ))),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15),
                                                      height: 55,
                                                      child: TextButton(
                                                          style: ButtonStyle(
                                                            padding: MaterialStateProperty.all(
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        15,
                                                                    horizontal:
                                                                        23)),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                          ),
                                                          onPressed: () {
                                                            chooseModal(
                                                                childItem[
                                                                    "title"]);
                                                            showModalBottomSheet<
                                                                    void>(
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                context:
                                                                    context,
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
                                                                          .8,
                                                                      child:
                                                                          ModalService(
                                                                        id: madichvu,
                                                                        title: childItem[
                                                                            "title"],
                                                                        activeCN:
                                                                            activeCN,
                                                                      ));
                                                                });
                                                          },
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Text(
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black),
                                                              "${childItem["title"]}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          )),
                                                    );
                                                  }).toList()),
                                            )
                                      ],
                                    ));
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Text(
                              "Lịch sắp tới",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            if (storageAuth.getItem("phone") != null)
                              FutureBuilder(
                                future: callBookingApi(
                                    storageAuth.getItem("phone")),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List list = snapshot.data!.toList();
                                    return FutureBuilder(
                                      future: callServiceApiById(
                                          list[0]!["ten_vt"] ?? ""),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Wrap(
                                            children: list.map((item) {
                                              return Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20),
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 8,
                                                        offset: const Offset(4,
                                                            4), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      padding: MaterialStateProperty
                                                          .all(const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 15,
                                                              horizontal: 15)),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.white),
                                                      shape: MaterialStateProperty.all(
                                                          const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8)))),
                                                    ),
                                                    onPressed: () {
                                                      showModalBottomSheet<
                                                              void>(
                                                          backgroundColor:
                                                              Colors.white,
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
                                                                    0.95,
                                                                child:
                                                                    ModalChiTietBooking(
                                                                  details:
                                                                      list[0],
                                                                  details2: snapshot
                                                                      .data![0],
                                                                ));
                                                          });
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                item["ten_vt"],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      15),
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary
                                                                      .withOpacity(
                                                                          0.2),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10))),
                                                              child: Text(
                                                                item[
                                                                    "dien_giai"],
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Tháng ${item["thang"] < 10 ? "0${item["thang"]}" : item["thang"]}, ${item["nam"]}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                Text(
                                                                  "${item["ngay"] < 10 ? "0${item["ngay"]}" : item["ngay"]}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          80),
                                                                )
                                                              ],
                                                            )),
                                                            Expanded(
                                                                child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/time-solid-black.png",
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      item[
                                                                          "time_book"],
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/location-solid-black.png",
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    FutureBuilder(
                                                                      future: callChiNhanhApiByCN(
                                                                          "${item["chi_nhanh"]}"),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (snapshot
                                                                            .hasData) {
                                                                          return Flexible(
                                                                              child: Text(
                                                                            "${snapshot.data![0]["exfields"]["dia_chi"]}, ${snapshot.data![0]["ten_kho"]}",
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w300),
                                                                          ));
                                                                        } else {
                                                                          return const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            }).toList(),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )
                          ],
                        ),
                      ),
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 23,
                            child: Container(
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
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                        vertical: 15,
                                      )),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                  onPressed: () {
                                    _makingPhoneCall();
                                  },
                                  child: Image.asset(
                                    "assets/images/call-black.png",
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  )),
                            )),
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                            flex: 75,
                            child: TextButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20)),
                                    shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40)))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.4))),
                                onPressed: () {
                                  Navigator.pushNamed(context, "tuvan");
                                },
                                child: Row(
                                  children: [
                                    Expanded(flex: 1, child: Container()),
                                    const Expanded(
                                      flex: 8,
                                      child: Center(
                                        child: Text(
                                          "Liên hệ tư vấn",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Image.asset(
                                        "assets/images/calendar-black.png",
                                        width: 40,
                                        height: 30,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  ],
                                )))
                      ],
                    ),
                  )
                ])));
  }
}
