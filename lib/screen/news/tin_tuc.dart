import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/newsModel.dart';
import 'package:ngoc_huong/screen/news/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';

class TinTucScreen extends StatefulWidget {
  const TinTucScreen({super.key});

  @override
  State<TinTucScreen> createState() => _TinTucScreenState();
}

class _TinTucScreenState extends State<TinTucScreen> {
  final LocalStorage storage = LocalStorage('auth');
  final NewsModel newsModel = NewsModel();

  @override
  Widget build(BuildContext context) {
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
              title: const Text("Tin tức",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: SingleChildScrollView(
                // reverse: true,
                child: Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 15),
                    child: FutureBuilder(
                      future: newsModel.getAllCustomerNews(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            return Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 15,
                              children: snapshot.data!.map((item) {
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
                                                type: "tin tức",
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(14)),
                                            child: Image.network(
                                              "",
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
                                                DateTime.parse(
                                                    item["date_updated"])),
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
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 40, bottom: 15),
                                  child: Image.asset(
                                      "assets/images/account/img.webp"),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Text(
                                    "Ngọc Hường chưa có tin tức",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            );
                          }
                        } else {
                          return const Row(
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
                          );
                        }
                      },
                    )))));
  }
}
