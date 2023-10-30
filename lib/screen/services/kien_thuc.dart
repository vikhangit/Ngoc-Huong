import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/models/newsModel.dart';
import 'package:ngoc_huong/screen/news/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class KienThucScreen extends StatefulWidget {
  const KienThucScreen({super.key});

  @override
  State<KienThucScreen> createState() => _KienThucScreenState();
}

class _KienThucScreenState extends State<KienThucScreen> {
  final NewsModel newsModel = NewsModel();
  @override
  Widget build(BuildContext context) {
    Future refreshData() async {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {});
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(active: 0),
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
              title: const Text("Kiến thức làm đẹp",
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
                      margin: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 15),
                      child: FutureBuilder(
                        future: newsModel.getCustomerNewsByGroup("Kiến thức làm đẹp"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 15,
                              children: snapshot.data!.map((item) {
                                // int index = uudaiList.indexOf(item);
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
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.95,
                                              child: ChiTietTinTuc(
                                                detail: item,
                                                type: "kiến thức",
                                              ));
                                        });
                                  },
                                  child: SizedBox(
                                      height: 205,
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          22.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(14)),
                                            child: Image.network(
                                              "${item["Image"]}",
                                              height: 135,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "${item["Title"]}",
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
                                                DateTime.parse(
                                                    item["ModifiedDate"])),
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
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ))),
            )));
  }
}
