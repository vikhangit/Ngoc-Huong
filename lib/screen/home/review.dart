import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/ModalPlayVideo.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/cosmetic/special_cosmetic.dart';
import 'package:ngoc_huong/screen/reviews/ReviewScreen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

int currentIndexPr = 0;

class _ReviewPageState extends State<ReviewPage> {
  final ProductModel productModel = ProductModel();
  final BannerModel bannerModel = BannerModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 3, right: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "REVIEW DỊCH VỤ TẠI THẨM MỸ VIỆN NGỌC HƯỜNG",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReviewScreen()));
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
            height: 5,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 480 : 215,
            child: FutureBuilder(
              future: bannerModel.getReviewServices(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  List<Widget> pages = List<Widget>.generate(
                      list.length >= 6 ? 6 : list.length,
                      (i) => GestureDetector(
                            onTap: () {
                              // $goodAppUrl${list[i]["video"]}?$token'
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ModalPlayVideo(
                                          item: list[i],
                                          url:
                                              "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4")));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 5, top: 5, bottom: 5, right: 5),
                              padding: const EdgeInsets.only(
                                  top: 6, left: 6, right: 6, bottom: 2),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      // height:
                                      //     MediaQuery.of(context).size.width >
                                      //             600
                                      //         ? 315
                                      //         : 140,
                                      child: HtmlWidget(
                                    list[i]["content"],
                                    customStylesBuilder: (element) {
                                      // if (element.localName == "iframe") {
                                      //   return {
                                      //     "width": "100%",
                                      //     "height": "100%"
                                      //   };
                                      // }
                                    },
                                  )),
                                  // Stack(
                                  //   children: [

                                  // Positioned.fill(
                                  //     child: Container(
                                  //         child: GestureDetector(
                                  //   child: Icon(
                                  //     Icons.smart_display,
                                  //     color: mainColor,
                                  //     size: 45,
                                  //   ),
                                  // )))
                                  //   ],
                                  // ),
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      "${list[i]["title"]}",
                                      textAlign: TextAlign.left,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          height: 1.1,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
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
                          height: MediaQuery.of(context).size.width > 600
                              ? 365
                              : 185,
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              aspectRatio: 16 / 9,
                              enlargeCenterPage: false,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndexPr = index;
                                });
                              },
                            ),
                            itemCount: (pages.length / 2).ceil(),
                            itemBuilder: (context, index, realIndex) {
                              final int first = index * 2;
                              final int? three = index * 2 < pages.length - 1
                                  ? first + 1
                                  : null;
                              // pages.length - 1 == 2
                              //     ? null
                              //     : first > 2
                              //         ? null
                              //         : first + 1;
                              return Row(
                                children: [first, three].map((idx) {
                                  return Expanded(
                                    // flex: 1,
                                    child: Container(
                                      child: idx == null
                                          ? Container()
                                          : pages[idx],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                        if (pages.length > 2)
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(top: 8),
                            child: DotsIndicator(
                              dotsCount: (pages.length / 2).ceil(),
                              position: currentIndexPr,
                              decorator: DotsDecorator(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  size: Size(24, 8),
                                  activeSize: Size(24, 8),
                                  color: Color(0xFFECECEC),
                                  activeColor: mainColor,
                                  activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  spacing: EdgeInsets.all(0)),
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
