import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/screen/voucher_detail/voucher_detail.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class VoucherTest extends StatefulWidget {
  const VoucherTest({super.key});

  @override
  State<VoucherTest> createState() => _VoucherTestState();
}

int activeDot = 0;

class _VoucherTestState extends State<VoucherTest> {
  final BannerModel bannerModel = BannerModel();
  final CustomModal customModal = CustomModal();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 12.5, right: 12.5),
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "VOUCHER",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                ),
              ),
              GestureDetector(
                  onTap: () {},
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
        SizedBox(
          height: 15,
        ),
        FutureBuilder(
            future: bannerModel.getVoucher(),
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
                                () => Navigator.of(context).pop(),
                                () => Navigator.of(context).pop());
                          },
                          child: Container(
                              height: 120,
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
                  height: 120,
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
    var pages = list.map((e) {
      int index = list.indexOf(e);
      return Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VoucherDetail(
                            detail: e,
                          )));
            },
            child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "$goodAppUrl${e["picture"]}?$token",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            )),
          ),
          Positioned(
              right: activeDot == index ? 35 : 20,
              left: activeDot == index ? 35 : 20,
              bottom: -10,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "LẤY NGAY",
                        style: TextStyle(
                            fontSize: 12,
                            height: 1,
                            color: mainColor,
                            fontWeight: FontWeight.w800),
                      ),
                      Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(1000))),
                          child: const Center(
                            child: Text(
                              ">",
                              style: TextStyle(
                                  fontSize: 18,
                                  height: 1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ))
                    ],
                  ),
                ),
              ))
        ],
      );
    }).toList();

    return pages.length > 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    clipBehavior: Clip.none,
                    height: 120,
                    enlargeCenterPage: true,
                    viewportFraction: 0.55,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
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
                margin: const EdgeInsets.only(top: 25),
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
                      builder: (context) => VoucherDetail(
                            detail: list[0],
                          )));
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                height: 150,
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
                  child: Image.network(
                    "$goodAppUrl${list[0]["picture"]}?$token",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                )),
          );
  }
}
