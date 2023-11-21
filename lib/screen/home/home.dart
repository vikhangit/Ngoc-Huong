import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dynamic_carousel_indicator/dynamic_carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/newsModel.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/account/buy_history/buy_history.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_dia_chi.dart';
import 'package:ngoc_huong/screen/cart/cart.dart';
import 'package:ngoc_huong/screen/choose_brand/chooseBrand.dart';
import 'package:ngoc_huong/screen/cosmetic/cosmetic.dart';
import 'package:ngoc_huong/screen/cosmetic/special_cosmetic.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/member/thanh_vien.dart';
import 'package:ngoc_huong/screen/news/tin_tuc.dart';
import 'package:ngoc_huong/screen/notifications/notification.dart';
import 'package:ngoc_huong/screen/services/all_service.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/news/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/screen/services/kien_thuc.dart';
import 'package:ngoc_huong/screen/services/special_service.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
import 'package:badges/badges.dart' as badges;
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List listBanner = [
  "assets/images/Home/banner1.jpg",
  "assets/images/Home/banner2.jpg",
  "assets/images/Home/banner3.jpg",
];

List toolServices = [
  {"icon": "assets/images/icon/icon1.png", "title": "Đặt lịch"},
  {"icon": "assets/images/icon/icon3.png", "title": "Lịch sử làm đẹp"},
  {"icon": "assets/images/location-to.png", "title": "Chi nhánh gần nhất"},
  {"icon": "assets/images/icon/icon4.png", "title": "Hạng thành viên"},
  {"icon": "assets/images/icon/icon5.png", "title": "Ưu đãi tháng"},
  // {"icon": "assets/images/Home/Icon/dich-vu.png", "title": "Dịch vụ"},
  // {"icon": "assets/images/Home/Icon/vi.png", "title": "Điểm"},
  // {"icon": "assets/images/list-order.png", "title": "Lịch sử mua hàng"},
];
bool showAppBar = false;
int current = 0;
String tokenfirebase = "";
int activeCarousel = 0;

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final NotificationService notificationService = NotificationService();
  final CarouselController controller = CarouselController();
  final ProfileModel profileModel = ProfileModel();
  final ServicesModel servicesModel = ServicesModel();
  final CustomModal customModal = CustomModal();
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final LocalStorage storageBranch = LocalStorage('branch');
  final ProductModel productModel = ProductModel();
  final OrderModel orderModel = OrderModel();
  final CartModel cartModel = CartModel();
  final BookingModel bookingModel = BookingModel();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.setupFlutterNotifications();
    notificationService.setupInteractMessage(context);
    // notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value) {
      print("Token: $value");
      setState(() {
        tokenfirebase = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  void goToService(BuildContext context, int index) {
    if (storageCustomerToken.getItem("customer_token") != null) {
      switch (index) {
        case 0:
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookingServices()));
            break;
          }
        case 1:
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookingHistory(
                          ac: 1,
                        )));
            break;
          }
        case 2:
          {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ChooseBrandScreen(
            //               saveCN: () => setState(() {}),
            //             )));
            showModalBottomSheet<void>(
                backgroundColor: Colors.white,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      height: MediaQuery.of(context).size.height * .95,
                      child: ModalDiaChi(saveCN: () => setState(() {})));
                });
            break;
          }
        case 3:
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ThanhVienScreen()));
            break;
          }

        case 4:
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TinTucScreen()));
            break;
          }
        // case 7:
        //   {
        //     orderModel.getStatusList().then((value) => Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => BuyHistory(
        //               listTab: value,
        //             ))));
        //
        //     break;
        //   }
        default:
          {
            break;
          }
      }
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void goPage(index, reason) {
    activeCarousel = index;
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    print("-------------------------------------");
    print(storageCustomerToken.getItem("customer_token"));
    print("---------------------------------------");
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: ScrollToHide(
            scrollController: scrollController,
            height: 70,
            child: const MyBottomMenu(
              active: 0,
            )),
        appBar: null,
        body: RefreshIndicator(
          onRefresh: () => refreshData(),
          child: ListView(
            controller: scrollController,
            children: [
              listView(context, (context, index) => goToService(context, index),
                  (index, reason) => goPage(index, reason)),
            ],
          ),
        ),
      ),
    );
  }

  Widget listView(
      BuildContext context,
      Function(BuildContext context, int index) goToService,
      Function(int index, CarouselPageChangedReason reason) goToPage) {
    final ServicesModel servicesModel = ServicesModel();
    final NewsModel newsModel = NewsModel();
    final ProductModel productModel = ProductModel();
    final LocalStorage storageCustomerToken = LocalStorage('customer_token');
    final ProfileModel profileModel = ProfileModel();
    final CartModel cartModel = CartModel();
    final BookingModel bookingModel = BookingModel();
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 360,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 250,
                  child: CarouselSlider.builder(
                    itemCount: 3,
                    options: CarouselOptions(
                        height: 250,
                        // aspectRatio: 26 / 14,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        viewportFraction: 1,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          goToPage(index, reason);
                        }),
                    itemBuilder: (context, index, realIndex) {
                      return ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(15)),
                        child: Image.asset("assets/images/banner.png",
                            fit: BoxFit.fill),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.5, color: Colors.black38))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                storageCustomerToken
                                            .getItem("customer_token") !=
                                        null
                                    ? FutureBuilder(
                                        future: profileModel.getProfile(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            Map profile = snapshot.data!;
                                            return Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (_) => Dialog(
                                                        backgroundColor:
                                                            Colors.black,
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 350,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      "${profile["CustomerImage"]}"),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: SizedBox(
                                                    width: 35,
                                                    height: 35,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          const Color(
                                                              0xff00A3FF),
                                                      backgroundImage: NetworkImage(
                                                          "${profile["CustomerImage"]}"),
                                                      radius: 35.0,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Hi, ${profile["CustomerName"]}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: mainColor),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () => Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ThanhVienScreen())),
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 4),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      99999)),
                                                          color: Color.fromRGBO(
                                                              223, 223, 223, 1),
                                                        ),
                                                        child: const Text(
                                                          "Thành viên vàng >",
                                                          style: TextStyle(
                                                              fontSize: 9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            );
                                          } else {
                                            return const SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: LoadingIndicator(
                                                colors: kDefaultRainbowColors,
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
                                                strokeWidth: 1,
                                                // pathBackgroundColor: Colors.black45,
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen())),
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.account_circle_outlined,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  "Đăng nhập",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              ],
                                            )),
                                      ),
                                Row(
                                  children: [
                                    Text(
                                      "900 điểm",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: mainColor),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    FutureBuilder(
                                      future: cartModel.getProductCartList(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: Offset(0,
                                                      2), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (storageCustomerToken
                                                        .getItem(
                                                            "customer_token") !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (contex) =>
                                                              CartScreen()));
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginScreen()));
                                                }
                                              },
                                              child: Image.asset(
                                                "assets/images/icon/cart.png",
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: LoadingIndicator(
                                              colors: kDefaultRainbowColors,
                                              indicatorType:
                                                  Indicator.lineSpinFadeLoader,
                                              strokeWidth: 1,
                                              // pathBackgroundColor: Colors.black45,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                      future: bookingModel.getNotifications(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: const Offset(0,
                                                      2), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                                onTap: () {
                                                  if (storageCustomerToken
                                                          .getItem(
                                                              "customer_token") !=
                                                      null) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const NotificationScreen()));
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginScreen()));
                                                  }
                                                },
                                                child: Stack(
                                                  children: [
                                                    Icon(
                                                      Icons.notifications,
                                                      color: mainColor,
                                                    ),
                                                    Positioned(
                                                        right: 0,
                                                        top: 4,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 10,
                                                              height: 10,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                      mainColor),
                                                              child: Text(
                                                                  "${snapshot.data!.length}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          6,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                            )))
                                                  ],
                                                )),
                                          );
                                        } else {
                                          return const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: LoadingIndicator(
                                              colors: kDefaultRainbowColors,
                                              indicatorType:
                                                  Indicator.lineSpinFadeLoader,
                                              strokeWidth: 1,
                                              // pathBackgroundColor: Colors.black45,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: toolServices.map((item) {
                                int index = toolServices.indexOf(item);
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width / 5 -
                                      15,
                                  // height:90,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 0))),
                                    onPressed: () {
                                      goToService(context, index);
                                    },
                                    child: Column(
                                      children: [
                                        index == 2
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Image.asset(
                                                  width: 48,
                                                  height: 48,
                                                  "${item["icon"]}",
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 6),
                                                child: Image.asset(
                                                  width: 35,
                                                  height: 35,
                                                  "${item["icon"]}",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                        Text(
                                          "${item["title"]}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 12.5, right: 12.5),
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ĐĂNG KÝ THÀNH VIÊN",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Nhận ngay voucher làm đẹp 100.000đ và rất nhiều quà tặng",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.amber,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 12.5, right: 12.5),
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "FLASH SALE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: mainColor,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const TinTucScreen()));
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.only(right: 20),
                  //     child: Text(
                  //       "Xem thêm...",
                  //       style: TextStyle(
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.w400,
                  //           color: mainColor,
                  //           fontStyle: FontStyle.italic),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              Container(
                height: 15,
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/banner-flash.png",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ]),
          ),
          ServicesPage(),
          ProductPage(),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "KHUYẾN MÃI HOT",
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
                                builder: (context) => const TinTucScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 20),
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
                Container(
                  height: 15,
                ),
                SizedBox(
                  child: FutureBuilder(
                    future: newsModel.getCustomerNewsByGroup("Tin khuyến mãi"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List list = snapshot.data!.toList();
                        if (list.isEmpty) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 0, bottom: 10),
                                child: Image.asset(
                                    "assets/images/account/img.webp"),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 40),
                                child: const Text(
                                  "Xin lỗi! Hiện tại Ngọc Hường chưa có ưu đãi và khuyến mãi",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Wrap(
                            spacing: 15,
                            runSpacing: 15,
                            children: list
                                .sublist(0, list.length > 6 ? 6 : list.length)
                                .map((item) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChiTietTinTuc(
                                                detail: item,
                                                type: "khuyến mãi",
                                              )));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      17.5,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              "${item["Image"]}",
                                              // "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 200,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "${item["Title"]}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10,
                                                height: 1.2,
                                                color: mainColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
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
          ),
        ],
      ),
    );
  }
}

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

int currentIndex = 0;

class _ServicesPageState extends State<ServicesPage> {
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
            padding: EdgeInsets.symmetric(horizontal: 12.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "DỊCH VỤ NỔI BẬT",
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
                            builder: (context) =>
                                const SpecialServiceScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
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
                          onTap: () => showModalBottomSheet<void>(
                              backgroundColor: Colors.white,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    height: MediaQuery.of(context).size.height *
                                        0.85,
                                    child: ChiTietScreen(
                                      detail: list[i],
                                    ));
                              }),
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
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
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
                                  child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                            backgroundColor: Colors.white,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.85,
                                                  child: ChiTietScreen(
                                                    detail: list[i],
                                                  ));
                                            });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          color: mainColor,
                                        ),
                                        child: Text("Xem thêm",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.amber)),
                                      )),
                                )
                              ],
                            ),
                          )));

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 210,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              aspectRatio: 2.0,
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

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

int currentIndexPr = 0;

class _ProductPageState extends State<ProductPage> {
  final ProductModel productModel = ProductModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "SẢN PHẨM BÁN CHẠY",
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
                              builder: (context) =>
                                  const SpecialCosmeticScreen()));
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
              future: productModel.getHotProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  List<Widget> pages = List<Widget>.generate(
                      list.length,
                      (i) => GestureDetector(
                            onTap: () => showModalBottomSheet<void>(
                                backgroundColor: Colors.white,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.85,
                                      child: ProductDetail(
                                        details: list[i],
                                      ));
                                }),
                            child: Container(
                              margin: EdgeInsets.only(
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
                                    offset: Offset(
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
                                              "${list[i]["Image_Name"]}",
                                              // "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${list[i]["Name"]}",
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10,
                                            height: 1.3,
                                            color: mainColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${list[i]["CategoryCode"]}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10,
                                            height: 1.2,
                                            color: mainColor,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
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
                                        onTap: () {
                                          showModalBottomSheet<void>(
                                              backgroundColor: Colors.white,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.85,
                                                    child: ChiTietScreen(
                                                      detail: list[i],
                                                    ));
                                              });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            color: mainColor,
                                          ),
                                          child: Text(
                                              "${NumberFormat.currency(locale: "vi_VI", symbol: "").format(list[i]["PriceInbound"])} Đ",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.amber)),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ));

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 220,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              aspectRatio: 16 / 9,
                              enlargeCenterPage: false,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndexPr = index;
                                });
                              },
                            ),
                            itemCount: (pages.length / 3).round(),
                            itemBuilder: (context, index, realIndex) {
                              final int first = index * 3;
                              final int? second = first + 1;
                              final int? three =
                                  (pages.length / 3).round() % 3 > 0 &&
                                          first > 2
                                      ? null
                                      : second! + 1;
                              return Row(
                                children: [first, second, three].map((idx) {
                                  return idx != null
                                      ? Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: pages[idx],
                                          ),
                                        )
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
                          position: currentIndexPr,
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
