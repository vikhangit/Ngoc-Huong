import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/newsModel.dart';
import 'package:ngoc_huong/screen/news/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/screen/news/tin_tuc.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class Promotion extends StatefulWidget {
  const Promotion({super.key});

  @override
  State<Promotion> createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  final NewsModel newsModel = NewsModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Khuyến mãi và tin làm đẹp".toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TinTucScreen()));
                },
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    "Xem thêm...",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mainColor,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 15,
          ),
          SizedBox(
            child: FutureBuilder(
              future: newsModel.getAllCustomerNews(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  if (list.isEmpty) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 10),
                          child: Image.asset("assets/images/account/img.webp"),
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
                      children: list.map((item) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChiTietTinTuc(detail: item)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2 - 17.5,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        "$goodAppUrl${item["picture"]}?$token",
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
                                      "${item["title"]}",
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
          ),
        ],
      ),
    );
  }
}
