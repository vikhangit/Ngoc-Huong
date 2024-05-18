import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/gift_shop/allVoucher.dart';
import 'package:ngoc_huong/screen/gift_shop/chi_tiet_uu_dai.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/screen/voucher_detail/voucher_detail.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

int currentIndexPr = 0;

class _VoucherPageState extends State<VoucherPage> {
  final ProductModel productModel = ProductModel();
  final BannerModel bannerModel = BannerModel();
  final CustomModal customModal = CustomModal();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.5),
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllVoucherScreen()));
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
            height: 240,
            child: FutureBuilder(
              future: bannerModel.getVoucher(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  List newList = [];
                  for (var i = 0; i < list.length; i++) {
                    if (
                        // DateTime.parse(list[i]["hieu_luc_tu"]).isBefore(now) &&
                        //   DateTime.parse(list[i]["hieu_luc_den"]).isAfter(now) &&
                        list[i]["shared"]) {
                      newList.add(list[i]);
                    }
                  }
                  List<Widget> pages = List<Widget>.generate(
                      newList.length >= 6 ? 6 : newList.length,
                      (i) => GestureDetector(
                            onTap: () {
                              DateTime now = DateTime.now();
                              if (DateTime.parse(newList[i]["hieu_luc_den"])
                                  .isBefore(now)) {
                                customModal.showAlertDialog(
                                    context,
                                    "error",
                                    "Lỗi mua voucher",
                                    "Rất tiếc voucher này đã hết hạn!!!",
                                    () => Navigator.of(context).pop(),
                                    () => Navigator.of(context).pop());
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VoucherDetail(
                                              detail: newList[i],
                                            )));
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VoucherDetail(
                                            detail: list[i],
                                          )));
                            },
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
                                                offset: Offset(0,
                                                    1), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              "$goodAppUrl${list[i]["banner1"]}?$token",
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        list[i]["ten"],
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
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
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
                                                  "assets/images/icon/Xu1.png",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  "${list[i]["giabanxu"]}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.amber),
                                                ),
                                              ],
                                            ))),
                                  )
                                ],
                              ),
                            ),
                          ));

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: pages.isEmpty
                        ? Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 0, bottom: 10),
                                child: Image.asset(
                                  "assets/images/account/img.webp",
                                  height: 140,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 40),
                                child: const Text(
                                  "Xin lỗi! Hiện tại Ngọc Hường chưa phát hành voucher",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                    height: 220,
                                    aspectRatio: 16 / 9,
                                    enlargeCenterPage: false,
                                    viewportFraction: 1,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        currentIndexPr = index;
                                      });
                                    },
                                  ),
                                  itemCount: (pages.length / 3).ceil(),
                                  itemBuilder: (context, index, realIndex) {
                                    final int first = index * 3;
                                    final int? second =
                                        index * 3 < pages.length - 2
                                            ? first + 1 > pages.length - 2
                                                ? null
                                                : first + 1
                                            : null;
                                    final int? three =
                                        index * 3 < pages.length - 1
                                            ? first + 2 > pages.length - 1
                                                ? null
                                                : first + 2
                                            : null;
                                    return Row(
                                      children:
                                          [first, second, three].map((idx) {
                                        return Expanded(
                                          flex: 1,
                                          child: idx != null
                                              ? Container(
                                                  child: pages[idx],
                                                )
                                              : Container(),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              if (pages.length > 3)
                                DotsIndicator(
                                  dotsCount: (pages.length / 3).ceil(),
                                  position: currentIndexPr,
                                  decorator: DotsDecorator(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      size: Size(12, 8),
                                      activeSize: Size(24, 8),
                                      color: mainColor,
                                      activeColor: mainColor,
                                      activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
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
