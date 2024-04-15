import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/ModalPlayVideo.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/cosmetic/special_cosmetic.dart';
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
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "REVIEW DỊCH VỤ TẠI THẨM MỸ VIỆN NGỌC HƯỜNG",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 15,
          ),
          SizedBox(
            height: 260,
            child: FutureBuilder(
              future: bannerModel.getReviewServices(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  List<Widget> pages = List<Widget>.generate(
                      list.length,
                      (i) => GestureDetector(
                            onTap: () {
                              print(list[i]["content"]);
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
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
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
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 150,
                                      child: HtmlWidget(
                                        list[i]["content"],
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
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "${list[i]["title"]}",
                                      textAlign: TextAlign.left,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 10,
                                          height: 1.3,
                                          color: mainColor,
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
                          height: 225,
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
                            itemCount: (pages.length / 2).round(),
                            itemBuilder: (context, index, realIndex) {
                              final int first = index * 2;
                              final int? three = pages.length - 1 == 2
                                  ? null
                                  : first > 2
                                      ? null
                                      : first + 1;
                              return Row(
                                children: [first, three].map((idx) {
                                  return idx != null
                                      ? Expanded(
                                          // flex: 1,
                                          child: Container(
                                            child: pages[idx],
                                          ),
                                        )
                                      : Container();
                                }).toList(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        DotsIndicator(
                          dotsCount: (pages.length / 2).round(),
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

class VideoPlay extends StatefulWidget {
  final String path;
  const VideoPlay({super.key, required this.path});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.networkUrl(Uri.parse(widget.path));
    videoController.addListener(() {
      setState(() {});
    });
    videoController.setLooping(true);
    videoController.initialize().then((_) => setState(() {}));
    _controller = AnimationController(vsync: this);
    videoController.pause();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.path);
    return SizedBox.expand(
        child: Container(
      child: videoController.value.isInitialized
          ? AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              child: VideoPlayer(videoController),
            )
          : Container(),
    ));
  }
}
