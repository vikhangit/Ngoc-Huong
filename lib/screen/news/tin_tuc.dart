import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/newsModel.dart';
import 'package:ngoc_huong/screen/news/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class TinTucScreen extends StatefulWidget {
  const TinTucScreen({super.key});

  @override
  State<TinTucScreen> createState() => _TinTucScreenState();
}

class _TinTucScreenState extends State<TinTucScreen> {
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
              title: const Text("Khuyến mãi hot",
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
                    child: SizedBox(
                      child: FutureBuilder(
                        future: newsModel.getCustomerNewsByGroup("Tin khuyến mãi"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List list = snapshot.data!.toList();
                            if (list.isEmpty) {
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 0, bottom: 10),
                                    child:
                                    Image.asset("assets/images/account/img.webp"),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 40),
                                    child: const Text(
                                      "Xin lỗi! Hiện tại Ngọc Hường chưa có ưu đãi và khuyến mãi",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Wrap(
                                spacing: 15,
                                runSpacing: 15,
                                children: list
                                    .map((item) {
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
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.85,
                                                child: ChiTietTinTuc(
                                                  detail: item,
                                                  type: "khuyến mãi",
                                                ));
                                          });
                                    },
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width / 2 - 25,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: Offset(0, 1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: Image.network(
                                                  "${item["Image"]}",
                                                  // "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                                  fit: BoxFit.cover,
                                                  width:
                                                  MediaQuery.of(context).size.width,
                                                  height: 200,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "${item["Title"]}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    height: 1.2,
                                                    color: mainColor,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
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
                      ),
                    )))));
  }
}
