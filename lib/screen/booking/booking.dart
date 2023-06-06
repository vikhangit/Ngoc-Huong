import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_services.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_dia_chi.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class BookingServices extends StatefulWidget {
  const BookingServices({super.key});

  @override
  State<BookingServices> createState() => _BookingServicesState();
}

String maKho = "";
int choose = -1;
String chooseName = "";
String madichvu = "";
int activeServiceParent = -1;
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
    "child": [
      {"title": "Dịch vụ cấy"},
      {"title": "Dịch vụ xóa"},
      {"title": "Dịch vụ khác"},
    ]
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
  @override
  void initState() {
    setState(() {
      for (var i = 0; i < chooseService.length; i++) {
        chooseService[i]["show"] = false;
      }
      activeServiceParent = -1;
      choose = -1;
      chooseName = "";
      madichvu = "";
      maKho = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var i = 0; i < chooseService.length; i++) {
      chooseService[i]["show"] = false;
    }
    activeServiceParent = -1;
    choose = -1;
    chooseName = "";
    madichvu = "";
    super.dispose();
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
    if (choose < 0) {
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
                      chooseDiaChi: (index, makho) =>
                          chooseDiaChi(index, makho),
                      active: choose,
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
      for (var i = 0; i < chooseService.length; i++) {
        if (index == i) {
          setState(() {
            chooseService[i]["show"] = !chooseService[i]["show"];
          });
        }
      }
    }
  }

  void chooseDiaChi(int index, String makho) {
    setState(() {
      choose = index;
      maKho = makho;
    });
  }

  void chooseModal(String name) {
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
      case "Dịch vụ cấy":
        {
          setState(() {
            madichvu = "64756af6706fa019e6720d26";
          });
          break;
        }
      case "Dịch vụ xóa":
        {
          setState(() {
            madichvu = "64756ab8706fa019e6720cee";
          });
          break;
        }
      case "Dịch vụ khác":
        {
          setState(() {
            madichvu = "64756b06706fa019e6720d40";
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
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(
              active: 5,
            ),
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
                                    chooseDiaChi: (index, makho) =>
                                        chooseDiaChi(index, makho),
                                    active: choose,
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
                              FutureBuilder(
                                future: callChiNhanhApi(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                        choose > -1
                                            ? snapshot.data![choose]["ten_kho"]
                                            : "Đặt lịch",
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
                              ),
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
            body: SingleChildScrollView(
              // reverse: true,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Chọn dịch vụ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                                  offset: const Offset(
                                      4, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 28)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: const Radius.circular(10),
                                                bottom: Radius.circular(
                                                    item["show"] == false
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
                                              fontWeight: FontWeight.w300),
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
                                              Icons.keyboard_arrow_up_outlined,
                                              color: Colors.black,
                                              size: 24,
                                            )
                                    ],
                                  ),
                                ),
                                if (item["show"] == true)
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10))),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: item["child"]
                                            .map<Widget>((childItem) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ))),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            height: 55,
                                            child: TextButton(
                                                style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 15,
                                                              horizontal: 23)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                ),
                                                onPressed: () {
                                                  chooseModal(
                                                      childItem["title"]);
                                                  showModalBottomSheet<void>(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      context: context,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              15.0),
                                                        ),
                                                      ),
                                                      isScrollControlled: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery
                                                                        .of(
                                                                            context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                .8,
                                                            child: ModalService(
                                                                id: madichvu,
                                                                title: childItem[
                                                                    "title"],
                                                                maKho: maKho));
                                                      });
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black),
                                                    "${childItem["title"]}",
                                                    textAlign: TextAlign.left,
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
                      "Lịch đã hẹn",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    FutureBuilder(
                      future: callBookingApi(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Wrap(
                            children: snapshot.data!.map((item) {
                              return Container(
                                  margin: const EdgeInsets.only(top: 20),
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
                                              vertical: 15, horizontal: 15)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)))),
                                    ),
                                    onPressed: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                item["ten_vt"],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Text(
                                                item["dien_giai"],
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Tháng ${item["thang"] < 10 ? "0${item["thang"]}" : item["thang"]}, ${item["nam"]}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  "${item["ngay"] < 10 ? "0${item["ngay"]}" : item["ngay"]}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 80),
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
                                                      height: 20,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      item["time_book"],
                                                      style: const TextStyle(
                                                          color: Colors.black,
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/location-solid-black.png",
                                                      width: 20,
                                                      height: 20,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    FutureBuilder(
                                                      future: callChiNhanhApiByCN(
                                                          "${item["chi_nhanh"]}"),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Flexible(
                                                              child: Text(
                                                            "${snapshot.data![0]["exfields"]["dia_chi"]}, ${snapshot.data![0]["ten_kho"]}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ));
                                                        } else {
                                                          return Container(
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
                    )
                  ],
                ),
              ),
            )));
  }
}
