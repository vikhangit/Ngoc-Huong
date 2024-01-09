import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/cart/cart_success.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
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
        Navigator.pop(context);
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
      }, () => Navigator.pop(context));
    }

    void updateCart(Map item) async {
      customModal.showAlertDialog(context, "error", "Giỏ hàng",
          "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
        Navigator.pop(context);
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
      }, () => Navigator.pop(context));
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          // bottomNavigationBar: ScrollToHide(
          //     scrollController: scrollController,
          //     height: 100,
          //     child: const MyBottomMenu(
          //       active: 0,
          //     )),
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.10000000149011612),
                                  offset: Offset(0, 3),
                                  blurRadius: 8)
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            child: Image.network(
                              "https://api.goodapp.vn/${newsDetail["picture"]}?access_token=028e7792d98ffa9234c1eb257b0f0a22",
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                              ),
                              "a": Style(
                                  textDecoration: TextDecoration.none,
                                  color: Colors.black),
                              "img": Style(
                                  height: Height.auto(),
                                  width:
                                      Width(MediaQuery.of(context).size.width)),
                              "*:not(img)": Style(
                                  lineHeight: const LineHeight(1.5),
                                  margin: Margins.only(
                                      left: 0, top: 10, bottom: 10))
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Column(
                  children: [
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                vertical: 15, horizontal: 10),
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
                                    horizontal: 10, vertical: 15),
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
                                    vertical: 15, horizontal: 10),
                                child: TextButton(
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
                                                      "customer_token") ==
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
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                const SizedBox(width: 15),
                                                Image.asset(
                                                  "assets/images/calendar-black.png",
                                                  width: 24,
                                                  height: 24,
                                                  fit: BoxFit.contain,
                                                ),
                                              ],
                                            ))
                              ),
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
