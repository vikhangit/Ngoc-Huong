import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/ModalZoomImage.dart';
import 'package:ngoc_huong/screen/account/voucher/voucherSuccess.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:upgrader/upgrader.dart';

class VoucherBuyDetail extends StatefulWidget {
  final Map detail;
  const VoucherBuyDetail({super.key, required this.detail});

  @override
  State<VoucherBuyDetail> createState() => _VoucherBuyDetailState();
}

Map profile = {};

class _VoucherBuyDetailState extends State<VoucherBuyDetail> {
  final ScrollController scrollController = ScrollController();
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final LocalStorage localStorageCustomerCart = LocalStorage("customer_cart");
  final CustomModal customModal = CustomModal();
  final ProfileModel profileModel = ProfileModel();
  final BannerModel bannerModel = BannerModel();

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
            title: const Text("Chi tiết voucher của tôi",
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
              child: FutureBuilder(
                  future: bannerModel.getVoucherByMaVoucher(
                      widget.detail["details"][0]["ma_evoucher"]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map newsDetail = snapshot.data!;
                      print(newsDetail);
                      return ListView(
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
                                "${int.tryParse(widget.detail["dien_giai"].toString().replaceAll("lần", ""))}/${newsDetail["so_lan_sd"]}",
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
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
                          // Row(
                          //   children: [
                          //     const Text(
                          //       "Đã thanh toán: ",
                          //       textAlign: TextAlign.left,
                          //       overflow: TextOverflow.ellipsis,
                          //       maxLines: 1,
                          //       style: TextStyle(
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w600),
                          //     ),
                          //     const SizedBox(
                          //       width: 5,
                          //     ),
                          // Text(
                          //   // widget.detail["hinh_thuc_tt"] == "KHAC"
                          //   //     ? "Xu"
                          //   //     : widget.detail["hinh_thuc_tt"] == "TM"
                          //   //         ? "Tiền mặt"
                          //   //         : "",
                          //   "${newsDetail["giabanxu"]} xu",
                          //   textAlign: TextAlign.left,
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 1,
                          //   style: const TextStyle(
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Image.asset(
                          //       "assets/images/icon/Xu1.png",
                          //       width: 20,
                          //       height: 20,
                          //     ),
                          //     const SizedBox(
                          //       width: 3,
                          //     ),
                          //     Text(
                          //       "${newsDetail["giabanxu"]}",
                          //       style: const TextStyle(
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w400,
                          //           color: Colors.black),
                          //     ),
                          //   ],
                          // )
                          //   ],
                          // ),
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
                            child: Html(
                              data: newsDetail["voucher"]["content"],
                              style: {
                                "*": Style(
                                    fontSize: FontSize(15),
                                    textAlign: TextAlign.justify),
                                "a": Style(
                                    textDecoration: TextDecoration.none,
                                    color: Colors.black),
                                "img": Style(
                                    height: Height.auto(),
                                    width: Width(
                                        MediaQuery.of(context).size.width)),
                                "*:not(img)": Style(
                                    lineHeight: const LineHeight(1.5),
                                    margin: Margins.only(
                                        left: 0, top: 10, bottom: 10))
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: LoadingIndicator(
                            colors: kDefaultRainbowColors,
                            indicatorType: Indicator.lineSpinFadeLoader,
                            strokeWidth: 1,
                            // pathBackgroundColor: Colors.black45,
                          ),
                        ),
                      );
                    }
                  }))),
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
