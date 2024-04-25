import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/ModalZoomImage.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/cart/cart_success.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';
import 'package:upgrader/upgrader.dart';

class FlashSaleDetail extends StatefulWidget {
  final Map detail;
  const FlashSaleDetail({super.key, required this.detail});

  @override
  State<FlashSaleDetail> createState() => _FlashSaleDetailState();
}

class _FlashSaleDetailState extends State<FlashSaleDetail> {
  final ScrollController scrollController = ScrollController();
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final LocalStorage localStorageCustomerCart = LocalStorage("customer_cart");
  final CartModel cartModel = CartModel();
  final CustomModal customModal = CustomModal();
  final ServicesModel servicesModel = ServicesModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    Map newsDetail = widget.detail;

    void addToCart() async {
      customModal.showAlertDialog(context, "error", "Giỏ hàng",
          "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
        Navigator.of(context).pop();
        EasyLoading.show(status: "Vui lòng chờ...");
        Future.delayed(const Duration(seconds: 2), () {
          Map data = {
            "DetailList": [
              {
                "Amount": newsDetail["Price"] * 1,
                "Price": newsDetail["Price"],
                "PrinceTest": newsDetail["Price"] * 1,
                "ProductCode": newsDetail["ProductCode"],
                "ProductId": newsDetail["ProductId"],
                "Quantity": 1,
              }
            ]
          };
          cartModel.addToCart(data).then((value) {
            EasyLoading.dismiss();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCartSuccess()));
          });
        });
      }, () => Navigator.of(context).pop());
    }

    void updateCart(Map item) async {
      customModal.showAlertDialog(context, "error", "Giỏ hàng",
          "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
        Navigator.of(context).pop();
        EasyLoading.show(status: "Vui lòng chờ...");
        Future.delayed(const Duration(seconds: 2), () {
          cartModel.updateProductInCart({
            // "Id": 1,
            "DetailList": [
              {
                ...item,
                "Ammount": (item["Quantity"] + 1) * item["Price"],
                "Quantity": (item["Quantity"] + 1)
              }
            ]
          }).then((value) {
            EasyLoading.dismiss();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCartSuccess()));
          });
        });
      }, () => Navigator.of(context).pop());
    }

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
            title: const Text("Chi tiêt FLASH SALE",
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
                        vertical: 15, horizontal: 15),
                    children: [
                      ImageDetail(item: newsDetail),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              newsDetail["ten_chietkhau"],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${DateFormat("dd/MM/yyyy").format(DateTime.parse(newsDetail["tu_ngay"]))} - ${DateFormat("dd/MM/yyyy").format(DateTime.parse(newsDetail["den_ngay"]))}",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        child: Html(
                          data: newsDetail["dien_giai"],
                          style: {
                            "*": Style(
                                fontSize: FontSize(15),
                                margin: Margins.symmetric(horizontal: 0),
                                textAlign: TextAlign.justify),
                            "a": Style(
                                textDecoration: TextDecoration.none,
                                color: Colors.black),
                            "img": Style(
                                height: Height.auto(),
                                width: Width(
                                    MediaQuery.of(context).size.width - 35),
                                margin: Margins(left: Margin(0))),
                            "*:not(img)": Style(
                                lineHeight: const LineHeight(1.5),
                                margin:
                                    Margins.only(left: 0, top: 5, bottom: 5))
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 20)),
                          ),
                          onPressed: () {
                            makingPhoneCall();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Điện thoại nhận tư vấn",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Image.asset(
                                "assets/images/call-black.png",
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ],
                          )),
                    ),
                    newsDetail["TypeProduct"] == "service"
                        ? Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: FutureBuilder(
                                future: servicesModel.getServiceByCode(
                                    newsDetail["ProductCode"]),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return TextButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20)),
                                            shape: MaterialStateProperty.all(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)))),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.4))),
                                        onPressed: () {
                                          if (storageCustomerToken
                                                  .getItem("customer_token") ==
                                              null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen()));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookingServices(
                                                          dichvudachon:
                                                              snapshot.data,
                                                        )));
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Đặt lịch hẹn",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(width: 15),
                                            Image.asset(
                                              "assets/images/calendar-black.png",
                                              width: 24,
                                              height: 24,
                                              fit: BoxFit.contain,
                                            ),
                                          ],
                                        ));
                                  } else {
                                    return const Center(
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: LoadingIndicator(
                                          colors: kDefaultRainbowColors,
                                          indicatorType:
                                              Indicator.lineSpinFadeLoader,
                                          strokeWidth: 1,
                                          // pathBackgroundColor: Colors.black45,
                                        ),
                                      ),
                                    );
                                  }
                                }))
                        : newsDetail["TypeProduct"] == "product"
                            ? Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                color: Colors.white,
                                child: FutureBuilder(
                                  future: cartModel.getDetailCartByCode(
                                      newsDetail["ProductCode"].toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return TextButton(
                                          style: ButtonStyle(
                                              padding: MaterialStateProperty.all(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20)),
                                              shape: MaterialStateProperty.all(
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)))),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.4))),
                                          onPressed: () {
                                            if (storageCustomerToken.getItem(
                                                    "customer_token") !=
                                                null) {
                                              // print(snapshot.data!);
                                              if (snapshot.data!.isNotEmpty) {
                                                updateCart(snapshot.data!);
                                              } else {
                                                addToCart();
                                              }
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()));
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Thêm vào giỏ hàng",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const SizedBox(width: 15),
                                              Image.asset(
                                                "assets/images/cart-black.png",
                                                width: 24,
                                                height: 24,
                                                fit: BoxFit.contain,
                                              ),
                                            ],
                                          ));
                                    } else {
                                      return const Center(
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: LoadingIndicator(
                                            colors: kDefaultRainbowColors,
                                            indicatorType:
                                                Indicator.lineSpinFadeLoader,
                                            strokeWidth: 1,
                                            // pathBackgroundColor: Colors.black45,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            : Container(
                                height: 50,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 20)),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)))),
                                        backgroundColor: MaterialStateProperty.all(Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.4))),
                                    onPressed: () {
                                      if (storageCustomerToken
                                              .getItem("customer_token") ==
                                          null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BookingServices()));
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Đặt lịch hẹn",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(width: 15),
                                        Image.asset(
                                          "assets/images/calendar-black.png",
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ))),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                )
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
      widget.item["picture"],
      widget.item["picture2"],
      widget.item["picture3"]
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
                      "$goodAppUrl${widget.item["picture"]}?$token",
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
