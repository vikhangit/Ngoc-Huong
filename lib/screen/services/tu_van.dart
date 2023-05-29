import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/modal/modal_chi_nhanh_tu_van.dart';
import 'package:ngoc_huong/screen/services/modal/modal_dich_vu_tu_van.dart';

class TuVanScreen extends StatefulWidget {
  const TuVanScreen({super.key});

  @override
  State<TuVanScreen> createState() => _TuVanScreenState();
}

int activeChiNhanhTuVan = -1;
List chiNhanhTuVan = ["TP Hồ Chí Minh", "Hà Nội", "Đà Nẵng", "Cần Thơ"];
int activeDichVuTuVan = -1;
List dichvuTuVan = ["Dịch vụ 1", "Dịch vụ 2", "Dịch vụ 3", "Dịch vụ 4"];

class _TuVanScreenState extends State<TuVanScreen> {
  void chooseChiNhanhTuVan(int index) {
    setState(() {
      activeChiNhanhTuVan = index;
    });
    Navigator.pop(context);
  }

  void chooseDichVuTuVan(int index) {
    setState(() {
      activeDichVuTuVan = index;
    });
    Navigator.pop(context);
  }

  String dateTuVan = "";
  void selectDate(BuildContext context) {
    DatePickerBdaya.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2010, 3, 5),
        maxTime: DateTime(3000, 12, 31),
        theme: const DatePickerThemeBdaya(
          itemStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          doneStyle: TextStyle(fontSize: 14),
        ),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        dateTuVan = DateFormat("dd/MM/yyyy").format(date);
      });
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 0,
            // ),
            appBar: AppBar(
              centerTitle: true,
              bottomOpacity: 0.0,
              elevation: 0.0,
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
              title: const Text("Tư vấn",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            drawer: const MyLeftMenu(),
            body: Column(
              // reverse: true,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  height: MediaQuery.of(context).size.height - 300,
                  child: ListView(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/logo2.png",
                          width: 102,
                          height: 54,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Tên",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            TextField(
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary), //<-- SEE HERE
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey), //<-- SEE HERE
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 18),
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.3),
                                    fontWeight: FontWeight.w400),
                                hintText: 'Nhập tên',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Số điện thoại",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            TextField(
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary), //<-- SEE HERE
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey), //<-- SEE HERE
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 18),
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.3),
                                    fontWeight: FontWeight.w400),
                                hintText: 'Nhập số điện thoại',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Chi nhánh",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
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
                                            MediaQuery.of(context).size.height *
                                                .8,
                                        child: ModalChiNhanhTuVan(
                                          chooseChiNhanhTuVan: (index) =>
                                              chooseChiNhanhTuVan(index),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 18),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      activeChiNhanhTuVan < 0
                                          ? "Chọn chi nhánh"
                                          : "${chiNhanhTuVan[activeChiNhanhTuVan]}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: activeChiNhanhTuVan < 0
                                              ? Colors.black.withOpacity(0.3)
                                              : Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: activeChiNhanhTuVan < 0
                                          ? Colors.black.withOpacity(0.3)
                                          : Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Dịch vụ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
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
                                            MediaQuery.of(context).size.height *
                                                .8,
                                        child: ModalDichVuTuVan(
                                          chooseDichVuTuVan: (index) =>
                                              chooseDichVuTuVan(index),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 18),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      activeDichVuTuVan < 0
                                          ? "Chọn dịch vụ"
                                          : "${dichvuTuVan[activeDichVuTuVan]}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: activeDichVuTuVan < 0
                                              ? Colors.black.withOpacity(0.3)
                                              : Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: activeDichVuTuVan < 0
                                          ? Colors.black.withOpacity(0.3)
                                          : Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 15),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Container(
                      //         margin: const EdgeInsets.only(bottom: 7),
                      //         child: const Text(
                      //           "Ngày tư vấn",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w500,
                      //               fontSize: 14),
                      //         ),
                      //       ),
                      //       TextField(
                      //         textAlignVertical: TextAlignVertical.center,
                      //         controller: TextEditingController(
                      //           text:
                      //               dateTuVan.isNotEmpty ? dateTuVan : "",
                      //         ),
                      //         readOnly: true,
                      //         onTap: () => selectDate(context),
                      //         style: const TextStyle(
                      //             fontSize: 14,
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.w400),
                      //         decoration: InputDecoration(
                      //           suffixIcon: const Icon(
                      //             Icons.calendar_month_outlined,
                      //             color: Colors.black45,
                      //           ),
                      //           focusedBorder: OutlineInputBorder(
                      //             borderRadius: const BorderRadius.all(
                      //                 Radius.circular(10)),
                      //             borderSide: BorderSide(
                      //                 width: 1,
                      //                 color: Theme.of(context)
                      //                     .colorScheme
                      //                     .primary), //<-- SEE HERE
                      //           ),
                      //           enabledBorder: const OutlineInputBorder(
                      //             borderRadius: BorderRadius.all(
                      //                 Radius.circular(10)),
                      //             borderSide: BorderSide(
                      //                 width: 1,
                      //                 color: Colors.grey), //<-- SEE HERE
                      //           ),
                      //           contentPadding:
                      //               const EdgeInsets.symmetric(
                      //                   horizontal: 15, vertical: 18),
                      //           hintStyle: TextStyle(
                      //               fontSize: 14,
                      //               color: Colors.black.withOpacity(0.3),
                      //               fontWeight: FontWeight.w400),
                      //           hintText: 'Nhập ngày sinh',
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                  child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)))),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 20))),
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
                                width: 25,
                                height: 30,
                                fit: BoxFit.contain,
                              ))
                        ],
                      )),
                )
              ],
            )));
  }
}
