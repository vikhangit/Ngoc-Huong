import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/cosmetic/cosmetic.dart';
import 'package:ngoc_huong/screen/cosmetic/special_cosmetic.dart';
import 'package:ngoc_huong/screen/gift_shop/allProduct.dart';
import 'package:ngoc_huong/screen/gift_shop/chi_tiet_uu_dai.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class ShopProductPage extends StatefulWidget {
  const ShopProductPage({super.key});

  @override
  State<ShopProductPage> createState() => _ShopProductPageState();
}

int currentIndexPr = 0;

class _ShopProductPageState extends State<ShopProductPage> {
  final ProductModel productModel = ProductModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "SẢN PHẨM",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      productModel
                          .getGroupProduct()
                          .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Cosmetic(
                                        listTab: value,
                                        isShop: true,
                                      ))));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "Xem thêm...",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: mainColor,
                            fontStyle: FontStyle.italic),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            height: 15,
          ),
          SizedBox(
            height: 270,
            child: FutureBuilder(
              future: productModel.getHotProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  List<Widget> pages = List<Widget>.generate(
                      list.length,
                      (i) => GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                          details: list[i],
                                          detailPage: true,
                                          isShop: true,
                                        ))),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 5, top: 5, bottom: 5, right: 5),
                              width: MediaQuery.of(context).size.width,
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
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
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
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: const Offset(0,
                                                    1), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              "${list[i]["Image_Name"]}",
                                              // "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${list[i]["Name"]}",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10,
                                            height: 1.3,
                                            color: mainColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${list[i]["CategoryCode"]}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10,
                                            height: 1.2,
                                            color: mainColor,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                              color: mainColor,
                                            ),
                                            child: list[i]["ExchangeCoin"] !=
                                                    null
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/icon/Xu1.png",
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        "${list[i]["ExchangeCoin"]}",
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.amber),
                                                      ),
                                                    ],
                                                  )
                                                : const Text(
                                                    "Đang cập nhật...",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.amber),
                                                  ))),
                                  )
                                ],
                              ),
                            ),
                          ));

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 250,
                              aspectRatio: 16 / 9,
                              enlargeCenterPage: false,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndexPr = index;
                                });
                              },
                            ),
                            itemCount: (pages.length / 3).round(),
                            itemBuilder: (context, index, realIndex) {
                              final int first = index * 3;
                              final int? second = first + 1;
                              final int? three =
                                  (pages.length / 3).round() % 3 > 0 &&
                                          first > 2
                                      ? null
                                      : second! + 1;
                              return Row(
                                children: [first, second, three].map((idx) {
                                  return Expanded(
                                    flex: 1,
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
                        const SizedBox(
                          height: 8,
                        ),
                        DotsIndicator(
                          dotsCount: (pages.length / 3).round(),
                          position: currentIndexPr,
                          decorator: DotsDecorator(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              size: Size(12, 8),
                              activeSize: Size(24, 8),
                              color: mainColor,
                              activeColor: mainColor,
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              spacing: EdgeInsets.all(1)),
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
