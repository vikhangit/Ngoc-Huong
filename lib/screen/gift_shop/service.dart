import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/gift_shop/allService.dart';
import 'package:ngoc_huong/screen/gift_shop/chi_tiet_uu_dai.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/services/special_service.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class ShopServicesPage extends StatefulWidget {
  const ShopServicesPage({super.key});

  @override
  State<ShopServicesPage> createState() => _ShopServicesPageState();
}

int currentIndex = 0;

class _ShopServicesPageState extends State<ShopServicesPage> {
  final ServicesModel servicesModel = ServicesModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "DỊCH VỤ",
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
                            builder: (context) => const AllServiceScreen()));
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
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 15,
          ),
          SizedBox(
            height: 230,
            child: FutureBuilder(
              future: servicesModel.getHotServices(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  List<Widget> pages = List<Widget>.generate(
                      list.length,
                      (i) => GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GiftShopDetail(
                                        details: list[i],
                                        type: "service",
                                      ))),
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 5,
                              top: 5,
                              bottom: 5,
                              right: 5,
                            ),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        "${list[i]["Image_Name"] ?? "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${list[i]["Name"]}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: mainColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
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
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChiTietScreen(
                                                        detail: list[i])));
                                      },
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/images/icon/Xu.png",
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                "100",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ))),
                                )
                              ],
                            ),
                          )));

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              aspectRatio: 2.0,
                              height: 210,
                              enlargeCenterPage: false,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                            itemCount: (pages.length / 3).round(),
                            itemBuilder: (context, index, realIndex) {
                              final int first = index * 3;
                              final int? second = first + 1;
                              final int? three = second! + 1;
                              return Row(
                                children: [first, second, three].map((idx) {
                                  return idx != null
                                      ? Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: pages[idx],
                                          ))
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
                          dotsCount: (pages.length / 3).round(),
                          position: currentIndex,
                          decorator: DotsDecorator(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              size: const Size(12, 8),
                              activeSize: const Size(24, 8),
                              color: mainColor,
                              activeColor: mainColor,
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              spacing: const EdgeInsets.all(1)),
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
