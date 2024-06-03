import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/ModalZoomImage.dart';
import 'package:ngoc_huong/screen/account/voucher/voucher.dart';
import 'package:ngoc_huong/screen/account/voucher/voucherSuccess.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:upgrader/upgrader.dart';

class VoucherDetail extends StatefulWidget {
  final Map detail;
  const VoucherDetail({super.key, required this.detail});

  @override
  State<VoucherDetail> createState() => _VoucherDetailState();
}

Map profile = {};
Map voucherBuy = {};

class _VoucherDetailState extends State<VoucherDetail> {
  final ScrollController scrollController = ScrollController();
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final LocalStorage localStorageCustomerCart = LocalStorage("customer_cart");
  final CustomModal customModal = CustomModal();
  final ProfileModel profileModel = ProfileModel();
  final BannerModel bannerModel = BannerModel();
  final CheckInModel checkInModel = CheckInModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
    profileModel.getProfile().then((value) => setState(() {
          profile = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    Map newsDetail = widget.detail;
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.west,
                    size: 16,
                    color: Colors.black,
                  ),
                )),
            title: const Text("Chi tiết Voucher",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          body: UpgradeAlert(
            upgrader: Upgrader(
              dialogStyle: UpgradeDialogStyle.cupertino,
              canDismissDialog: false,
              showLater: false,
              showIgnore: false,
              showReleaseNotes: false,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    children: [
                      ImageDetail(item: newsDetail),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              newsDetail["ten"],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Row(
                      //   children: [
                      //     const Text(
                      //       "Giá bán:",
                      //       textAlign: TextAlign.left,
                      //       overflow: TextOverflow.ellipsis,
                      //       maxLines: 1,
                      //       style: TextStyle(
                      //           fontSize: 14, fontWeight: FontWeight.w600),
                      //     ),
                      //     const SizedBox(
                      //       width: 5,
                      //     ),
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Image.asset(
                      //           "assets/images/icon/Xu1.png",
                      //           width: 20,
                      //           height: 20,
                      //         ),
                      //         const SizedBox(
                      //           width: 3,
                      //         ),
                      //         Text(
                      //           "${newsDetail["giabanxu"]}",
                      //           style: const TextStyle(
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w400,
                      //               color: Colors.black),
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      // ),

                      Row(
                        children: [
                          const Text(
                            "Số lần dùng:",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${newsDetail["so_lan_sd"]}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Ưu đãi nhận được:",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Giảm",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              const Text(
                                "đ",
                                style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 1,
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: "vi_VI", symbol: "")
                                    .format(newsDetail["so_tien"]),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Hạn sử dụng:",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${DateFormat("dd/MM/yyyy").format(DateTime.parse(newsDetail["hieu_luc_tu"]))} - ${DateFormat("dd/MM/yyyy").format(DateTime.parse(newsDetail["hieu_luc_den"]))}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Mô tả chi tiết về voucher".toUpperCase(),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        child: HtmlWidget(
                          newsDetail["voucher"]["content"],
                          // style: {
                          //   "*": Style(
                          //       fontSize: FontSize(15),
                          //       textAlign: TextAlign.justify),
                          //   "a": Style(
                          //       textDecoration: TextDecoration.none,
                          //       color: Colors.black),
                          //   "img": Style(
                          //       height: Height.auto(),
                          //       width:
                          //           Width(MediaQuery.of(context).size.width)),
                          //   "*:not(img)": Style(
                          //       lineHeight: const LineHeight(1.5),
                          //       margin:
                          //           Margins.only(left: 0, top: 10, bottom: 10))
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //     height: 50,
                //     margin: const EdgeInsets.symmetric(
                //         vertical: 15, horizontal: 15),
                //     child: TextButton(
                //         style: ButtonStyle(
                //             padding: MaterialStateProperty.all(
                //                 const EdgeInsets.symmetric(horizontal: 20)),
                //             shape: MaterialStateProperty.all(
                //                 RoundedRectangleBorder(
                //                     side:
                //                         BorderSide(color: mainColor, width: 1),
                //                     borderRadius:
                //                         BorderRadius.all(Radius.circular(15)))),
                //             backgroundColor:
                //                 MaterialStateProperty.all(Colors.white)),
                //         onPressed: () {
                //           if (storageCustomerToken.getItem("customer_token") ==
                //               null) {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => const LoginScreen()));
                //           } else {
                //             DateTime now = DateTime.now();
                //             if (DateTime.parse(newsDetail["hieu_luc_den"])
                //                     .isBefore(now) &&
                //                 newsDetail["status"]) {
                //               customModal.showAlertDialog(
                //                   context,
                //                   "error",
                //                   "Lỗi mua voucher",
                //                   "Xin lỗi quý khách hàng voucher này đã hết hạn!!!",
                //                   () => Navigator.of(context).pop(),
                //                   () => Navigator.of(context).pop());
                //             } else {
                //               bannerModel
                //                   .getVoucherBuyWithMaVoucher(
                //                       profile["Phone"], newsDetail["ma"])
                //                   .then((value) {
                //                 if (value.isNotEmpty) {
                //                   customModal.showAlertDialog(
                //                       context,
                //                       "error",
                //                       "Lỗi mua voucher",
                //                       "Bạn đã mua voucher này rồi vui lòng kiểm tra lại",
                //                       () => Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) => VoucherBuy(
                //                                   profile: profile))),
                //                       () => Navigator.of(context).pop());
                //                 } else {
                //                   if (profile["CustomerCoin"] == null ||
                //                       profile["CustomerCoin"] <
                //                           newsDetail["giabanxu"]) {
                //                     customModal.showAlertDialog(
                //                         context,
                //                         "error",
                //                         "Lỗi mua voucher",
                //                         "Bạn không đủ xu để mua voucher này",
                //                         () => Navigator.of(context).pop(),
                //                         () => Navigator.of(context).pop());
                //                   } else {
                //                     customModal.showAlertDialog(
                //                         context,
                //                         "error",
                //                         "Xác nhận mua voucher",
                //                         "Bạn chắc chắn dùng ${newsDetail["giabanxu"]} xu để mua voucher này?",
                //                         () {
                //                       Map item = {
                //                         "status": true,
                //                         "ngay_ct": DateFormat("yyyy/MM/dd")
                //                             .format(DateTime.now()),
                //                         "trang_thai": "0",
                //                         "t_sl": 1,
                //                         "t_tien_nt": 0,
                //                         "t_ck_nt": 0,
                //                         "t_thue_nt": 0,
                //                         "t_tt_nt": 0,
                //                         "han_tt": 0,
                //                         "id_ct_chuyen": "",
                //                         "ma_kh": profile["Phone"],
                //                         "dien_giai": "0 lần",
                //                         "details": [
                //                           {
                //                             "sl_xuat": 1,
                //                             "gia_ban_nt": 0,
                //                             "tien_nt": 0,
                //                             "ty_le_ck": 0,
                //                             "tien_ck_nt": 0,
                //                             "tien_thue_nt": 0,
                //                             "ma_evoucher": newsDetail["ma"],
                //                             "ten_evoucher": newsDetail["ten"],
                //                             "dien_giai": newsDetail["ten"],
                //                             "tk_dt": "1111",
                //                             "ten_tk_dt": "Tiền Việt Nam",
                //                             "line": 1715071092771
                //                           }
                //                         ],
                //                         "tk_no": "1111",
                //                         "ten_tk_no": "Tiền Việt Nam",
                //                         "so_ct": "1",
                //                         "ten_trang_thai": "Lập chứng từ",
                //                         "hinh_thuc_tt": "KHAC"
                //                       };
                //                       Navigator.of(context).pop();
                //                       EasyLoading.show();
                //                       Future.delayed(const Duration(seconds: 2),
                //                           () {
                //                         bannerModel
                //                             .addVoucherBuy(item)
                //                             .then((value) {
                //                           checkInModel
                //                               .userUsingCoin(
                //                                   newsDetail["giabanxu"])
                //                               .then((value2) {
                //                             Navigator.push(
                //                                 context,
                //                                 MaterialPageRoute(
                //                                     builder: (context) =>
                //                                         VoucherSuccess(
                //                                           details: value,
                //                                           profile: profile,
                //                                         )));
                //                             EasyLoading.dismiss();
                //                           });
                //                         });
                //                       });
                //                     }, () => Navigator.of(context).pop());
                //                   }
                //                 }
                //               });
                //             }
                //           }
                //         },
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(
                //               "Mua voucher",
                //               style: TextStyle(
                //                   color: mainColor,
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.w500),
                //             ),
                //             const SizedBox(width: 10),
                //             Image.asset(
                //               "assets/images/coupon.png",
                //               width: 26,
                //               height: 26,
                //             ),
                //           ],
                //         ))),
              ],
            ),
          )),
    );
  }
}

class ImageDetail extends StatefulWidget {
  final Map item;
  const ImageDetail({super.key, required this.item});

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

int currentIndex = 0;

class _ImageDetailState extends State<ImageDetail> {
  final CarouselController carouselController = CarouselController();
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  CustomModal customModal = CustomModal();

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    List newList = [
      widget.item["banner1"],
      widget.item["banner2"],
      widget.item["banner3"],
      widget.item["banner4"],
      widget.item["banner5"],
      widget.item["banner6"]
    ];
    List<String> result = [];
    for (var x in newList) {
      if (!["", null, false, 0].contains(x)) {
        result.add("$goodAppUrl$x?$token");
      }
    }

    List<Widget> imgList = List<Widget>.generate(
      result.length,
      (index) => Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              // color: checkColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ModalZoomImage(
                          currentIndex: currentIndex, imageList: result)));
            },
            child: Image.network(
              result[index],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              errorBuilder: (context, exception, stackTrace) {
                return Image.network(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitHeight,
                    'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
              },
            ),
          )),
    );

    return Container(
      // height: 200,
      width: MediaQuery.of(context).size.width,
      child: (imgList.length > 1)
          ? Column(
              children: [
                CarouselSlider.builder(
                    carouselController: carouselController,
                    options: CarouselOptions(
                      aspectRatio: 2,
                      height: 200,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    itemCount: imgList.length,
                    itemBuilder: (context, index, realIndex) => imgList[index]),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  child: Row(
                    // scrollDirection: Axis.horizontal,
                    // controller: scrollController,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: result.map((e) {
                      int index = result.indexOf(e);
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                              carouselController.animateToPage(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: index == 0 ? 0 : 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: currentIndex == index
                                      ? mainColor
                                      : Colors.white),
                            ),
                            child: Image.network(
                              e,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ));
                    }).toList(),
                  ),
                )
              ],
            )
          : imgList.length == 1
              ? Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      // color: checkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModalZoomImage(
                                  currentIndex: currentIndex,
                                  imageList: result)));
                    },
                    child: Image.network(
                      result[0],
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                      errorBuilder: (context, exception, stackTrace) {
                        return Image.network(
                            fit: BoxFit.cover,
                            'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
                      },
                    ),
                  ))
              : Container(
                  alignment: Alignment.center,
                  height: 200,
                  decoration: const BoxDecoration(
                      // color: checkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModalZoomImage(
                                      currentIndex: currentIndex,
                                      imageList: [
                                        "${widget.item["Image_Name"]}"
                                      ])));
                    },
                    child: Image.network(
                      "$goodAppUrl${widget.item["banner1"]}?$token",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                      errorBuilder: (context, exception, stackTrace) {
                        return Image.network(
                            fit: BoxFit.cover,
                            'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
                      },
                    ),
                  )),
    );
  }
}
