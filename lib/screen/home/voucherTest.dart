import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/account/voucher/voucher.dart';
import 'package:ngoc_huong/screen/account/voucher/voucherSuccess.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/screen/voucher_detail/voucher_detail.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

import 'package:ngoc_huong/screen/gift_shop/allVoucher.dart';

class VoucherTest extends StatefulWidget {
  const VoucherTest({super.key});

  @override
  State<VoucherTest> createState() => _VoucherTestState();
}

int activeDot = 0;
Map profile = {};

class _VoucherTestState extends State<VoucherTest> {
  final BannerModel bannerModel = BannerModel();
  final CustomModal customModal = CustomModal();
  final CheckInModel checkInModel = CheckInModel();
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');

  final ProfileModel profileModel = ProfileModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileModel.getProfile().then((value) => setState(() {
          profile = value;
        }));
  }

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
                  onTap: () {
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllVoucherScreen()));
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
                  if (
                      // DateTime.parse(list[i]["hieu_luc_tu"]).isBefore(now) &&
                      //   DateTime.parse(list[i]["hieu_luc_den"]).isAfter(now) &&
                      list[i]["shared"]) {
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
                                "Rất tiếc các voucher đã hết hạn",
                                () => Navigator.of(context).pop(),
                                () => Navigator.of(context).pop());
                          },
                          child: Container(
                              height: 220,
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
                // return _buildCarousel(list);
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
              DateTime now = DateTime.now();
              if (DateTime.parse(e["hieu_luc_den"]).isBefore(now)) {
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
                              detail: e,
                            )));
              }
            },
            child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "$goodAppUrl${e["banner1"]}?$token",
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
                onTap: () {
                  DateTime now = DateTime.now();
                  if (DateTime.parse(e["hieu_luc_den"]).isBefore(now)) {
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
                                  detail: e,
                                )));
                  }
                  // if (storageCustomerToken.getItem("customer_token") == null) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const LoginScreen()));
                  // } else {
                  //   DateTime now = DateTime.now();
                  //   if (DateTime.parse(e["hieu_luc_den"]).isBefore(now) &&
                  //       e["status"]) {
                  //     customModal.showAlertDialog(
                  //         context,
                  //         "error",
                  //         "Lỗi mua voucher",
                  //         "Xin lỗi quý khách hàng voucher này đã hết hạn!!!",
                  //         () => Navigator.of(context).pop(),
                  //         () => Navigator.of(context).pop());
                  //   } else {
                  //     bannerModel
                  //         .getVoucherBuyWithMaVoucher(profile["Phone"], e["ma"])
                  //         .then((value) {
                  //       if (value.isNotEmpty) {
                  //         if (value["dien_giai"]
                  //                 .toString()
                  //                 .trim()
                  //                 .toLowerCase() ==
                  //             "${e["so_lan_sd"]} lần".trim().toLowerCase()) {
                  //           if (profile["CustomerCoin"] == null ||
                  //               profile["CustomerCoin"] < e["giabanxu"]) {
                  //             customModal.showAlertDialog(
                  //                 context,
                  //                 "error",
                  //                 "Lỗi mua voucher",
                  //                 "Bạn không đủ xu để mua voucher này",
                  //                 () => Navigator.of(context).pop(),
                  //                 () => Navigator.of(context).pop());
                  //           } else {
                  //             customModal.showAlertDialog(
                  //                 context,
                  //                 "error",
                  //                 "Xác nhận mua voucher",
                  //                 "Bạn chắc chắn dùng ${e["giabanxu"]} xu để mua voucher này?",
                  //                 () {
                  //               Map item = {
                  //                 "status": true,
                  //                 "ngay_ct": DateFormat("yyyy/MM/dd")
                  //                     .format(DateTime.now()),
                  //                 "trang_thai": "0",
                  //                 "t_sl": 1,
                  //                 "t_tien_nt": 0,
                  //                 "t_ck_nt": 0,
                  //                 "t_thue_nt": 0,
                  //                 "t_tt_nt": 0,
                  //                 "han_tt": 0,
                  //                 "id_ct_chuyen": "",
                  //                 "ma_kh": profile["Phone"],
                  //                 "dien_giai": "0 lần",
                  //                 "details": [
                  //                   {
                  //                     "sl_xuat": 1,
                  //                     "gia_ban_nt": 0,
                  //                     "tien_nt": 0,
                  //                     "ty_le_ck": 0,
                  //                     "tien_ck_nt": 0,
                  //                     "tien_thue_nt": 0,
                  //                     "ma_evoucher": e["ma"],
                  //                     "ten_evoucher": e["ten"],
                  //                     "dien_giai": e["ten"],
                  //                     "tk_dt": "1111",
                  //                     "ten_tk_dt": "Tiền Việt Nam",
                  //                     "line": 1715071092771
                  //                   }
                  //                 ],
                  //                 "tk_no": "1111",
                  //                 "ten_tk_no": "Tiền Việt Nam",
                  //                 "so_ct": "1",
                  //                 "ten_trang_thai": "Lập chứng từ",
                  //                 "hinh_thuc_tt": "KHAC"
                  //               };
                  //               Navigator.of(context).pop();
                  //               EasyLoading.show();
                  //               Future.delayed(const Duration(seconds: 2), () {
                  //                 bannerModel.addVoucherBuy(item).then((value) {
                  //                   Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                           builder: (context) =>
                  //                               VoucherSuccess(
                  //                                 details: value,
                  //                                 profile: profile,
                  //                               )));
                  //                   EasyLoading.dismiss();
                  //                 });
                  //               });
                  //             }, () => Navigator.of(context).pop());
                  //           }
                  //         } else {
                  //           customModal.showAlertDialog(
                  //               context,
                  //               "error",
                  //               "Lỗi mua voucher",
                  //               "Bạn đã mua voucher này rồi vui lòng kiểm tra lại",
                  //               () => Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) =>
                  //                           VoucherBuy(profile: profile))),
                  //               () => Navigator.of(context).pop());
                  //         }
                  //       } else {
                  //         if (profile["CustomerCoin"] == null ||
                  //             profile["CustomerCoin"] < e["giabanxu"]) {
                  //           customModal.showAlertDialog(
                  //               context,
                  //               "error",
                  //               "Lỗi mua voucher",
                  //               "Bạn không đủ xu để mua voucher này",
                  //               () => Navigator.of(context).pop(),
                  //               () => Navigator.of(context).pop());
                  //         } else {
                  //           customModal.showAlertDialog(
                  //               context,
                  //               "error",
                  //               "Xác nhận mua voucher",
                  //               "Bạn chắc chắn dùng ${e["giabanxu"]} xu để mua voucher này?",
                  //               () {
                  //             Map item = {
                  //               "status": true,
                  //               "ngay_ct": DateFormat("yyyy/MM/dd")
                  //                   .format(DateTime.now()),
                  //               "trang_thai": "0",
                  //               "t_sl": 1,
                  //               "t_tien_nt": 0,
                  //               "t_ck_nt": 0,
                  //               "t_thue_nt": 0,
                  //               "t_tt_nt": 0,
                  //               "han_tt": 0,
                  //               "id_ct_chuyen": "",
                  //               "ma_kh": profile["Phone"],
                  //               "dien_giai": "0 lần",
                  //               "details": [
                  //                 {
                  //                   "sl_xuat": 1,
                  //                   "gia_ban_nt": 0,
                  //                   "tien_nt": 0,
                  //                   "ty_le_ck": 0,
                  //                   "tien_ck_nt": 0,
                  //                   "tien_thue_nt": 0,
                  //                   "ma_evoucher": e["ma"],
                  //                   "ten_evoucher": e["ten"],
                  //                   "dien_giai": e["ten"],
                  //                   "tk_dt": "1111",
                  //                   "ten_tk_dt": "Tiền Việt Nam",
                  //                   "line": 1715071092771
                  //                 }
                  //               ],
                  //               "tk_no": "1111",
                  //               "ten_tk_no": "Tiền Việt Nam",
                  //               "so_ct": "1",
                  //               "ten_trang_thai": "Lập chứng từ",
                  //               "hinh_thuc_tt": "KHAC"
                  //             };
                  //             Navigator.of(context).pop();
                  //             EasyLoading.show();
                  //             Future.delayed(const Duration(seconds: 2), () {
                  //               bannerModel.addVoucherBuy(item).then((value) {
                  //                 checkInModel
                  //                     .userUsingCoin(e["giabanxu"])
                  //                     .then((value2) {
                  //                   Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                           builder: (context) =>
                  //                               VoucherSuccess(
                  //                                 details: value,
                  //                                 profile: profile,
                  //                               )));
                  //                   EasyLoading.dismiss();
                  //                 });
                  //               });
                  //             });
                  //           }, () => Navigator.of(context).pop());
                  //         }
                  //       }
                  //     });
                  //   }
                  // }
                },
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
                    "$goodAppUrl${list[0]["banner1"]}?$token",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                )),
          );
  }
}
