import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/screen/services/modal/modal_chi_nhanh.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class KienThucScreen extends StatefulWidget {
  const KienThucScreen({super.key});

  @override
  State<KienThucScreen> createState() => _KienThucScreenState();
}

List kenThucList = [];
int activeChiNhanh = -1;
List chiNhanh = ["TP Hồ Chí Minh", "Hà Nội", "Đà Nẵng", "Cần Thơ"];

class _KienThucScreenState extends State<KienThucScreen> {
  @override
  void initState() {
    callNewsApi().then((value) => setState(() => kenThucList = value));
    super.initState();
  }

  void chooseChiNhanh(int index) {
    setState(() {
      activeChiNhanh = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(
              active: 0,
            ),
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
              title: const Text("Kiến thức làm đẹp",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            drawer: const MyLeftMenu(),
            body: SingleChildScrollView(
                // reverse: true,
                child: Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 15),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 15,
                children: kenThucList.map((item) {
                  // int index = uudaiList.indexOf(item);
                  return item["cate_name"].toString().toLowerCase() ==
                          "kiến thức"
                      ? InkWell(
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
                        )
                      : Container();
                }).toList(),
              ),
            ))));
  }
}
