import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class TinTucScreen extends StatefulWidget {
  const TinTucScreen({super.key});

  @override
  State<TinTucScreen> createState() => _TinTucScreenState();
}

List tinTucList = [];

int activeChiNhanh = -1;
List chiNhanh = ["TP Hồ Chí Minh", "Hà Nội", "Đà Nẵng", "Cần Thơ"];

class _TinTucScreenState extends State<TinTucScreen> {
  final LocalStorage storage = LocalStorage('auth');
  void chooseChiNhanh(int index) {
    setState(() {
      activeChiNhanh = index;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    callNewsApi("647015b9706fa019e66e9333")
        .then((value) => setState(() => tinTucList = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar:
                MyBottomMenu(active: 0, save: () => setState(() {})),
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
              title: const Text("Tin tức",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            drawer: const MyLeftMenu(),
            body: SingleChildScrollView(
                // reverse: true,
                child: Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 15),
              child: tinTucList.isNotEmpty
                  ? Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 15,
                      children: tinTucList.map((item) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                                backgroundColor: Colors.white,
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
                                              0.95,
                                      child: ChiTietTinTuc(
                                        detail: item,
                                        type: "tin tức",
                                      ));
                                });
                          },
                          child: SizedBox(
                              height: 205,
                              width:
                                  MediaQuery.of(context).size.width / 2 - 22.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(14)),
                                    child: Image.network(
                                      "$apiUrl${item["picture"]}?$token",
                                      height: 135,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "${item["title"]}",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: Color(0xFF212121),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    DateFormat("dd/MM/yyyy").format(
                                        DateTime.parse(item["date_updated"])),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF8B8B8B),
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )),
                        );
                      }).toList(),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ))));
  }
}
