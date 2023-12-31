import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dynamic_carousel_indicator/dynamic_carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/screen/flash_sale/flash_sale_detail.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/screen/voucher_detail/voucher_detail.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class Voucher extends StatefulWidget {
  const Voucher({super.key});

  @override
  State<Voucher> createState() => _VoucherState();
}

int activeDot = 0;

class _VoucherState extends State<Voucher> {
  final BannerModel bannerModel = BannerModel();
  final CustomModal customModal = CustomModal();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 12.5, right: 12.5),
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "VOUCHER",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: mainColor,
          ),
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
                      list[i]["trang_thai"] == "1") {
                    newList.add(list[i]);
                  }
                }
                return newList.isNotEmpty
                    ? _buildCarousel(newList)
                    : Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            customModal.showAlertDialog(
                                context,
                                "error",
                                "Voucher",
                                "Các voucher đã hết hạn",
                                () => Navigator.pop(context),
                                () => Navigator.pop(context));
                          },
                          child: Container(
                              height: 200,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/images/voucher1.png",
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                      );
              } else {
                return const SizedBox(
                  height: 250,
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
                        builder: (context) => VoucherDetail(
                              detail: e,
                            )));
              },
              child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/voucher1.png",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  )),
            ))
        .toList();

    return pages.length > 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    aspectRatio: 2.0,
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
              SizedBox(
                height: 8,
              ),
              DotsIndicator(
                dotsCount: pages.length,
                position: activeDot,
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
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VoucherDetail(
                            detail: list[0],
                          )));
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                margin:
                    const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/images/voucher1.png",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                )),
          );
  }
}
