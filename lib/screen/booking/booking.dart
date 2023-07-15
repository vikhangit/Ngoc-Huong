import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_dia_chi.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class BookingServices extends StatefulWidget {
  const BookingServices({super.key});

  @override
  State<BookingServices> createState() => _BookingServicesState();
}

bool showService = false;
int chooselevel1 = -1;
int chooselevel2 = -1;
List<DateTime?> _singleDatePickerValueWithDefaultValue = [
  DateTime.now(),
];
List<String> weekDaysName = [
  'CN',
  'Thứ 2',
  'Thứ 3',
  'Thứ 4',
  'Thứ 5',
  'Thứ 6',
  'Thứ 7'
];
String activeTime = "";
String madichvu = "";
List listMaDichVu = [];
String typeService = "";
Map serviceActiveType = {};
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

class _BookingServicesState extends State<BookingServices>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> animation;
  LocalStorage storageAuth = LocalStorage("auth");
  LocalStorage storageCN = LocalStorage('chi_nhanh');
  String activeDay = DateFormat("dd").format(
      DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
  String activeMonth = DateFormat("MM").format(
      DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
  String activeYear = DateFormat("yyyy").format(
      DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        upperBound: 0.5);

    setState(() {
      for (var i = 0; i < chooseService.length; i++) {
        chooseService[i]["show"] = false;
      }
      madichvu = "";
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    for (var i = 0; i < chooseService.length; i++) {
      chooseService[i]["show"] = false;
    }
    madichvu = "";
    _animationController.dispose();
    showService = false;
    super.dispose();
  }

  void chooseTime(String time) {
    setState(() {
      activeTime = time;
    });
  }

  void saveService(Map item) {
    setState(() {
      serviceActiveType = item;
    });
    Navigator.pop(context);
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

  void chooseModal(String name) {
    setState(() {
      madichvu = name;
    });
    switch (name) {
      case "Phun xăm mày":
        {
          setState(() {
            if (listMaDichVu.isNotEmpty) {
              int index = listMaDichVu.indexOf("647569c2706fa019e6720bd4");
              if (index < 0) {
                listMaDichVu.add("647569c2706fa019e6720bd4");
              } else {
                listMaDichVu.removeAt(index);
              }
            } else {
              listMaDichVu.add("647569c2706fa019e6720bd4");
            }
          });
          break;
        }
      case "Phun mí mắt":
        {
          setState(() {
            if (listMaDichVu.isNotEmpty) {
              int index = listMaDichVu.indexOf("647569cb706fa019e6720bee");
              if (index < 0) {
                listMaDichVu.add("647569cb706fa019e6720bee");
              } else {
                listMaDichVu.removeAt(index);
              }
            } else {
              listMaDichVu.add("647569cb706fa019e6720bee");
            }
          });
          break;
        }
      case "Phun xăm môi":
        {
          setState(() {
            if (listMaDichVu.isNotEmpty) {
              int index = listMaDichVu.indexOf("647569d6706fa019e6720c08");
              if (index < 0) {
                listMaDichVu.add("647569d6706fa019e6720c08");
              } else {
                listMaDichVu.removeAt(index);
              }
            } else {
              listMaDichVu.add("647569d6706fa019e6720c08");
            }
          });

          break;
        }
      case "Xóa, sửa lại":
        {
          setState(() {
            if (listMaDichVu.isNotEmpty) {
              int index = listMaDichVu.indexOf("64756a1c706fa019e6720c22");
              if (index < 0) {
                listMaDichVu.add("64756a1c706fa019e6720c22");
              } else {
                listMaDichVu.removeAt(index);
              }
            } else {
              listMaDichVu.add("64756a1c706fa019e6720c22");
            }
          });
          break;
        }
      case "Làm đẹp da":
        {
          setState(() {
            if (listMaDichVu.isNotEmpty) {
              int index = listMaDichVu.indexOf("64756979706fa019e6720b5d");
              if (index < 0) {
                listMaDichVu.add("64756979706fa019e6720b5d");
              } else {
                listMaDichVu.removeAt(index);
              }
            } else {
              listMaDichVu.add("64756979706fa019e6720b5d");
            }
          });
          break;
        }
      case "Tắm trắng":
        {
          setState(() {
            if (listMaDichVu.isNotEmpty) {
              int index = listMaDichVu.indexOf("64756b65706fa019e6720d91");
              if (index < 0) {
                listMaDichVu.add("64756b65706fa019e6720d91");
              } else {
                listMaDichVu.removeAt(index);
              }
            } else {
              listMaDichVu.add("64756b65706fa019e6720d91");
            }
          });

          break;
        }
      case "Triệt lông":
        {
          setState(() {
            if (listMaDichVu.isNotEmpty) {
              int index = listMaDichVu.indexOf("64756b31706fa019e6720d5d");
              if (index < 0) {
                listMaDichVu.add("64756b31706fa019e6720d5d");
              } else {
                listMaDichVu.removeAt(index);
              }
            } else {
              listMaDichVu.add("64756b31706fa019e6720d5d");
            }
          });
          break;
        }
      case "Giảm béo":
        {
          setState(() {
            if (listMaDichVu.isNotEmpty) {
              int index = listMaDichVu.indexOf("64756b56706fa019e6720d77");
              if (index < 0) {
                listMaDichVu.add("64756b56706fa019e6720d77");
              } else {
                listMaDichVu.removeAt(index);
              }
            } else {
              listMaDichVu.add("64756b56706fa019e6720d77");
            }
          });
          break;
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    Map chiNhanh = jsonDecode(storageCN.getItem("chi_nhanh"));

    void selectedItem(int index) {
      if (chooseService[index]["child"] == null) {
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
                              chiNhanh.isNotEmpty
                                  ? FutureBuilder(
                                      future: callChiNhanhApiByCN(
                                          chiNhanh["ma_kho"]),
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                                children: [
                                  Container(
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (showService) {
                                              _animationController.reverse(
                                                  from: 0.5);
                                            } else {
                                              _animationController.forward(
                                                  from: 0.0);
                                            }

                                            showService = !showService;
                                          });
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 15)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Chọn dịch vụ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            RotationTransition(
                                              turns: Tween(begin: 0.0, end: 1.0)
                                                  .animate(
                                                      _animationController),
                                              child: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                  AnimatedCrossFade(
                                      firstChild: Container(),
                                      secondChild: Column(
                                          children: chooseService.map((item) {
                                        int index = chooseService.indexOf(item);
                                        return Column(
                                          children: [
                                            SizedBox(
                                                child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 60,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      selectedItem(index);
                                                    },
                                                    style: ButtonStyle(
                                                        padding: MaterialStateProperty
                                                            .all(const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5,
                                                                horizontal:
                                                                    15))),
                                                    child: Row(
                                                      children: [
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
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                AnimatedCrossFade(
                                                    firstChild: Container(),
                                                    secondChild:
                                                        item["child"] != null
                                                            ? Column(
                                                                children: item[
                                                                        "child"]!
                                                                    .map<Widget>(
                                                                        (it) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              55,
                                                                          child:
                                                                              TextButton(
                                                                            style:
                                                                                ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 35))),
                                                                            onPressed:
                                                                                () {
                                                                              chooseModal(it["title"]);
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${it["title"]}",
                                                                                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )),
                                                                    ],
                                                                  );
                                                                }).toList(),
                                                              )
                                                            : Container(),
                                                    crossFadeState:
                                                        item["show"] == true
                                                            ? CrossFadeState
                                                                .showSecond
                                                            : CrossFadeState
                                                                .showFirst,
                                                    duration: 500.ms)
                                              ],
                                            )),
                                            if (index <
                                                chooseService.length - 1)
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            BoxConstraints
                                                                constraints) {
                                                      final boxWidth =
                                                          constraints
                                                              .constrainWidth();
                                                      double dashWidth = 10.0;
                                                      double dashHeight = 1;
                                                      final dashCount =
                                                          (boxWidth /
                                                                  (2 *
                                                                      dashWidth))
                                                              .floor();
                                                      return Flex(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        direction:
                                                            Axis.horizontal,
                                                        children: List.generate(
                                                            dashCount, (_) {
                                                          return SizedBox(
                                                            width: dashWidth,
                                                            height: dashHeight,
                                                            child: DecoratedBox(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                              .grey[
                                                                          300]),
                                                            ),
                                                          );
                                                        }),
                                                      );
                                                    },
                                                  )),
                                            if (index ==
                                                chooseService.length - 1)
                                              Container(
                                                height: 10,
                                              )
                                          ],
                                        );
                                      }).toList()),
                                      crossFadeState: !showService
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                      duration: 500.ms),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              child: _buildDefaultSingleDatePickerWithValue(),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Chọn giờ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  FutureBuilder(
                                    future: callTimeBookingApi(
                                        chiNhanh["ma_kho"],
                                        "$activeYear-$activeMonth-$activeDay"),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, bottom: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.3)),
                                          child: Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: 6,
                                              runSpacing: 10,
                                              children:
                                                  snapshot.data!.map((item) {
                                                int index = snapshot.data!
                                                    .indexOf(item);
                                                DateTime now = DateTime.now();
                                                DateTime dataBooking =
                                                    DateTime.parse(
                                                        "${activeYear}-${activeMonth}-${activeDay}T${item["time"]}:00.534Z");

                                                return InkWell(
                                                    onTap: () {
                                                      if (item["value"] ==
                                                          true) {
                                                      } else {
                                                        if (DateTime(
                                                                dataBooking
                                                                    .year,
                                                                dataBooking
                                                                    .month,
                                                                dataBooking.day,
                                                                dataBooking
                                                                    .hour,
                                                                dataBooking
                                                                    .minute,
                                                                dataBooking
                                                                    .second)
                                                            .isAfter(DateTime(
                                                                    now.year,
                                                                    now.month,
                                                                    now.day,
                                                                    now.hour,
                                                                    now.minute,
                                                                    now.second)
                                                                .add(const Duration(
                                                                    minutes:
                                                                        30)))) {
                                                          chooseTime(
                                                              item["time"]);
                                                        } else {
                                                          showAlertDialog(
                                                              context,
                                                              "Bạn vui lòng đặt lịch trước 30 phút");
                                                        }
                                                      }
                                                    },
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 6),
                                                          decoration: BoxDecoration(
                                                              color: item["value"] ==
                                                                      true
                                                                  ? Colors
                                                                      .grey[350]
                                                                  : Colors
                                                                      .white,
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary
                                                                      .withOpacity(
                                                                          activeTime == item["time"]
                                                                              ? 1
                                                                              : 0.1)),
                                                              borderRadius:
                                                                  const BorderRadius.all(
                                                                      Radius.circular(
                                                                          10))),
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  5 -
                                                              15,
                                                          child: Text(
                                                            "${DateFormat("HH:mm").format(dataBooking)}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ),
                                                        if (activeTime ==
                                                            item["time"])
                                                          Positioned(
                                                            right: -1,
                                                            top: -1,
                                                            child: Container(
                                                              width: 8,
                                                              height: 8,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                            ),
                                                          )
                                                      ],
                                                    ));
                                              }).toList()),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                              border: Border.all(
                                  width: 1, color: Colors.grey[400]!)),
                          child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 20)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () {
                                makingPhoneCall(
                                    chiNhanh["exfields"]["dien_thoai"]);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Điện thoại nhận tư vấn",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Image.asset(
                                    "assets/images/call-black.png",
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  )
                                ],
                              )),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          margin: const EdgeInsets.only(top: 15),
                          child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 20)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.4))),
                              onPressed: () {
                                Navigator.pushNamed(context, "tuvan");
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Liên hệ tư vấn",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Image.asset(
                                    "assets/images/calendar-black.png",
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  )
                ])));
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: Theme.of(context).colorScheme.primary,
      weekdayLabels: weekDaysName,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      dayTextStyle: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
      disabledDayTextStyle:
          const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
      selectableDayPredicate: (day) => !day
          .difference(DateTime.now().subtract(const Duration(days: 1)))
          .isNegative,
      customModePickerIcon: Container(),
      modePickerTextHandler: ({DateTime? monthDate}) {
        return "Tháng ${monthDate?.month}, ${monthDate?.year}";
      },
    );
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(4, 4), // changes position of shadow
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: CalendarDatePicker2(
            config: config,
            value: _singleDatePickerValueWithDefaultValue,
            onValueChanged: (dates) => setState(() {
                  _singleDatePickerValueWithDefaultValue = dates;
                  activeTime = "";
                })));
  }

  Widget buildAnimatedChild(double width, double height, double maxHeight) {
    return AnimatedPositioned(
      width: width,
      height: height,
      duration: const Duration(milliseconds: 500),
      top: showService ? maxHeight + height : -height,
      child: Container(
        color: Colors.blue,
        width: width,
        height: height,
      ),
    );
  }
}

enum ToastType { Info, Warning, Success, Error }

const List<Color> ToastColors = [
  Colors.blue,
  Colors.orange,
  Colors.green,
  Colors.redAccent
];

const List<Icon> ToastIcons = [
  Icon(
    Icons.info,
    color: Colors.white,
  ),
  Icon(
    Icons.info,
    color: Colors.white,
  ),
  Icon(
    Icons.check_circle,
    color: Colors.white,
  ),
  Icon(
    Icons.error,
    color: Colors.white,
  )
];

Widget Toast(String content, ToastType type) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 85),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: ToastColors[type.index],
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ToastIcons[type.index],
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    content,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget checkIcon(BuildContext context) {
  int index = 1;
  return Container(
    alignment: Alignment.center,
    width: 24,
    height: 24,
    margin: const EdgeInsets.only(right: 20),
    decoration: BoxDecoration(
        color: chooselevel1 == index ? Colors.green : Colors.white,
        border: Border.all(
            width: 1,
            color: chooselevel1 == index ? Colors.green : Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(8))),
    child: Container(
        child: chooselevel1 == index
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              )
            : null),
  );
}
