import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/cosmetic/special_cosmetic.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

int currentIndexPr = 0;

class _ProductPageState extends State<ProductPage> {
  final ProductModel productModel = ProductModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 22.5, right: 22.5, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "SẢN PHẨM BÁN CHẠY",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SpecialCosmeticScreen()));
                    },
                    child: Container(
                      child: const Text(
                        "Xem thêm...",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            height: 745,
            child: FutureBuilder(
              future: productModel.getHotProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  List<Widget> pages = List<Widget>.generate(
                      list.length >= 8 ? 8 : list.length,
                      (i) => GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                          details: list[i],
                                          detailPage: true,
                                        ))),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.network(
                                        "${list[i]["Image_Name"]}",
                                        // "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 220,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 5, right: 5),
                                        child: Text(
                                          "${list[i]["Name"]}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              height: 1.2,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 5, bottom: 10, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              child: Row(
                                            children: [
                                              Text(
                                                "đ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor: mainColor,
                                                    fontWeight: FontWeight.w600,
                                                    color: mainColor),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                NumberFormat.currency(
                                                        locale: "vi_VI",
                                                        symbol: "")
                                                    .format(list[i]
                                                        ["PriceOutbound"]),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: mainColor),
                                              )
                                            ],
                                          )),
                                        ),
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                          ),
                                          child: const Text("Mua Ngay",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 7.5),
                          color: const Color(0xFFCECECE),
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 680,
                              enlargeCenterPage: false,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndexPr = index;
                                });
                              },
                            ),
                            itemCount: (pages.length / 4).ceil(),
                            itemBuilder: (context, index, realIndex) {
                              final int first = index * 4;
                              final int? second = index * 4 < pages.length - 3
                                  ? first + 1 > pages.length - 3
                                      ? null
                                      : first + 1
                                  : null;
                              final int? three = index * 4 < pages.length - 2
                                  ? first + 2 > pages.length - 2
                                      ? null
                                      : first + 2
                                  : null;
                              final int? four = index * 4 < pages.length - 1
                                  ? first + 3 > pages.length - 1
                                      ? null
                                      : first + 3
                                  : null;
                              return Wrap(
                                runSpacing: 15,
                                spacing: 15,
                                children:
                                    [first, second, three, four].map((idx) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Container(
                                      child: idx != null
                                          ? pages[idx]
                                          : Container(),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                        if (pages.length > 4)
                          Container(
                            width: 100,
                            margin: const EdgeInsets.only(top: 15),
                            child: DotsIndicator(
                              dotsCount: (pages.length / 4).ceil(),
                              position: currentIndexPr,
                              decorator: DotsDecorator(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  size: const Size(24, 8),
                                  activeSize: const Size(24, 8),
                                  color: const Color(0xFFECECEC),
                                  activeColor: mainColor,
                                  activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  spacing: const EdgeInsets.all(0)),
                            ),
                          )
                      ],
                    ),
                  );
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
