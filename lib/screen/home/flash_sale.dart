import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/screen/flash_sale/flash_sale_detail.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class FlashSale extends StatefulWidget {
  const FlashSale({super.key});

  @override
  State<FlashSale> createState() => _FlashSaleState();
}

int activeDot = 0;

class _FlashSaleState extends State<FlashSale> {
  final BannerModel bannerModel = BannerModel();
  final CustomModal customModal = CustomModal();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 22.5, right: 22.5),
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "ƯU ĐÃI GIÁ HỜI",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: mainColor,
          ),
        ),
        Container(
          height: 15,
        ),
        FutureBuilder(
            future: bannerModel.getFlashSale(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DateTime now = DateTime.now();
                List list = snapshot.data!;

                List newList = [];
                for (var i = 0; i < list.length; i++) {
                  if (DateTime.parse(list[i]["tu_ngay"]).isBefore(now) &&
                      DateTime.parse(list[i]["den_ngay"]).isAfter(now) &&
                      list[i]["trang_thai"] == "2" &&
                      list[i]["shared"] == true) {
                    newList.add(list[i]);
                  }
                }
                return newList.isNotEmpty
                    ? _buildCarousel(newList)
                    : Container(
                        margin: EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            customModal.showAlertDialog(
                                context,
                                "error",
                                "Flash Sale",
                                "Các chương trình flash sale đã hết hạn",
                                () => Navigator.of(context).pop(),
                                () => Navigator.of(context).pop());
                            bannerModel.getFlashSale().then((value) {
                              print("=====================================");
                              print(value);
                              print("=====================================");
                            });
                          },
                          child: Container(
                              height: 180,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/images/Home/banner-sale.png",
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                      );
              } else {
                return const SizedBox(
                  height: 180,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: LoadingIndicator(
                        colors: kDefaultRainbowColors,
                        indicatorType: Indicator.lineSpinFadeLoader,
                        strokeWidth: 1,
                        // pathBackgroundColor: Colors.black45,
                      ),
                    ),
                  ),
                );
              }
            }),
      ]),
    );
  }

  Widget _buildCarousel(List list) {
    var pages = list
        .map((e) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FlashSaleDetail(
                            detail: e,
                          )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "$goodAppUrl${e["picture"]}?$token",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            )))
        .toList();

    return pages.length > 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 180,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    scrollPhysics: pages.length == 1
                        ? const ScrollPhysics(
                            parent: NeverScrollableScrollPhysics())
                        : null,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeDot = index;
                      });
                    },
                  ),
                  itemCount: pages.length,
                  itemBuilder: (context, index, realIndex) => pages[index],
                ),
              ),
              Container(
                width: 100,
                margin: EdgeInsets.only(top: 15),
                child: DotsIndicator(
                  dotsCount: pages.length,
                  position: activeDot,
                  decorator: DotsDecorator(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      size: Size(20, 8),
                      activeSize: Size(20, 8),
                      color: Color(0xFFECECEC),
                      activeColor: mainColor,
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      spacing: EdgeInsets.all(0)),
                ),
              )
            ],
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FlashSaleDetail(
                            detail: list[0],
                          )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "$goodAppUrl${list[0]["picture"]}?$token",
                width: MediaQuery.of(context).size.width,
                height: 180,
                fit: BoxFit.cover,
              ),
            ));
  }
}
