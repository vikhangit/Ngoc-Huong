import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_v3/flutter_html.dart';
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
import 'package:ngoc_huong/screen/cart/cart.dart';
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
  {"icon": "assets/images/Home/Icon/calendar.png", "title": "Đặt lịch"},
  {"icon": "assets/images/Home/Icon/my-pham.png", "title": "Mỹ phẩm"},
  {"icon": "assets/images/Home/Icon/dich-vu.png", "title": "Dịch vụ"},
  {"icon": "assets/images/Home/Icon/vi.png", "title": "Điểm"},
  {
    "icon": "assets/images/Home/Icon/membership.png",
    "title": "Hạng thành viên"
  },
  {"icon": "assets/images/Home/Icon/uu-dai.png", "title": "Ưu đãi"},
  {"icon": "assets/images/Home/Icon/history.png", "title": "Lịch sử làm đẹp"},
  {"icon": "assets/images/list-order.png", "title": "Lịch sử mua hàng"},
];
bool showAppBar = false;
int current = 0;
String tokenfirebase = "";
int activeCarousel = 0;

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  NotificationService notificationService = NotificationService();
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
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  void goToService(BuildContext context, int index) {
    if (index == 1) {
      productModel.getGroupProduct().then((value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Cosmetic(
                    listTab: value,
                  ))));
    } else if (index == 2) {
      servicesModel.getGroupServiceByBranch().then((value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AllServiceScreen(
                    listTab: value,
                  ))));
    } else {
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
          case 3:
            {
              customModal.showAlertDialog(
                  context,
                  "error",
                  "Xin Lỗi Quý Khách",
                  "Chúng tôi đang nâng cấp tính năng này",
                  () => Navigator.pop(context),
                  () => Navigator.pop(context));
              break;
            }
          case 4:
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ThanhVienScreen()));
              break;
            }
          case 5:
            {
              customModal.showAlertDialog(
                  context,
                  "error",
                  "Xin Lỗi Quý Khách",
                  "Chúng tôi đang nâng cấp tính năng này",
                  () => Navigator.pop(context),
                  () => Navigator.pop(context));
              break;
            }
          case 6:
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookingHistory(
                            ac: 0,
                          )));
              break;
            }
          case 7:
            {
              orderModel.getStatusList().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuyHistory(
                            listTab: value,
                          ))));

              break;
            }
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
print(storageCustomerToken.getItem("customer_token"));
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: const MyBottomMenu(
          active: 0,
        ),
        appBar: storageCustomerToken.getItem("customer_token") != null
            ? AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
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
                                      backgroundColor: Colors.black,
                                      insetPadding: const EdgeInsets.all(20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 350,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "${profile["CustomerImage"]}"),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff00A3FF),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Xin chào!",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "${profile["CustomerName"]}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )
                            ],
                          );
                        } else {
                          return const SizedBox(
                            width: 40,
                            height: 40,
                            child: LoadingIndicator(
                              colors: <Color>[
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white
                              ],
                              indicatorType: Indicator.lineSpinFadeLoader,
                              strokeWidth: 1,
                              // pathBackgroundColor: Colors.black45,
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen())),
                      child: Image.asset("assets/images/cart-solid-white.png",
                          width: 28, height: 28),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                      },
                      child: Image.asset(
                        "assets/images/notification-solid-empty.png",
                        width: 28,
                        height: 28,
                      ),
                    ),
                  )
                ],
              )
            : AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            color: Colors.white,
                            shape: BoxShape.circle),
                        child: Image.asset("assets/images/logo2.png")),
                    const Text(
                      "Ngọc Hường Xin chào!!!",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    height: 30,
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen())),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.white)),
                            child: Text(
                              "Đăng nhập",
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )),
                  )
                ],
              ),
        body: RefreshIndicator(
          onRefresh: () => refreshData(),
          child: ListView(
            children: [
              listView(context, (context, index) => goToService(context, index),
                  (index, reason) => goPage(index, reason)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget listView(
    BuildContext context,
    Function(BuildContext context, int index) goToService,
    Function(int index, CarouselPageChangedReason reason) goToPage) {
  final ServicesModel servicesModel = ServicesModel();
  final NewsModel newsModel = NewsModel();
  final ProductModel productModel = ProductModel();
  return SizedBox(
    child: Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: 250,
              child: CarouselSlider.builder(
                itemCount: 3,
                options: CarouselOptions(
                    height: 250,
                    aspectRatio: 26 / 14,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    viewportFraction: 1,
                    initialPage: 0,
                    onPageChanged: (index, reason) {
                      goToPage(index, reason);
                    }),
                itemBuilder: (context, index, realIndex) {
                  return Image.asset(
                    "assets/images/Home/banner-sale.png",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: const BorderRadius.all(Radius.circular(10)),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 7,
          //       offset: const Offset(0, 3), // changes position of shadow
          //     ),
          //   ],
          // ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            // scrollDirection: Axis.horizontal,
            children: toolServices.map((item) {
              int index = toolServices.indexOf(item);
              return SizedBox(
                width: MediaQuery.of(context).size.width / 4 - 8,
                // height:90,
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 0))),
                  onPressed: () {
                    goToService(context, index);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(width: 1, color: mainColor)),
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Image.asset(
                          width: 30,
                          height: 30,
                          "${item["icon"]}",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text(
                        "${item["title"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Dịch Vụ Nổi Bật",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
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
                    child: Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mainColor,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 30,
              ),
              SizedBox(
                height: 230,
                child: FutureBuilder(
                  future: servicesModel.getHotServices(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.toList();
                      return ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: list.sublist(0, 3).map((item) {
                            int index = list.indexOf(item);
                            return GestureDetector(
                              onTap: () => showModalBottomSheet<void>(
                                  backgroundColor: Colors.white,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.95,
                                        child: ChiTietScreen(
                                          detail: item,
                                        ));
                                  }),
                              child: Container(
                                margin:
                                    EdgeInsets.only(left: index == 0 ? 0 : 10),
                                width:
                                    MediaQuery.of(context).size.width / 2 - 45,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    border: Border.all(
                                        color: mainColor,
                                        width: 1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          "${item["Image_Name"] ?? "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 120,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${item["Name"]}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: TextButton(
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                                backgroundColor: Colors.white,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
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
                                                              0.95,
                                                      child: ChiTietScreen(
                                                        detail: item,
                                                      ));
                                                });
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      mainColor)),
                                          child: const Text("Xem thêm",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white))),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList());
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
        Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Sản Phẩm Bán Chạy",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
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
                    child: Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mainColor,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 30,
              ),
              SizedBox(
                height: 230,
                child: FutureBuilder(
                  future: productModel.getHotProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.toList();
                      return ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: list.sublist(0, 4).map((item) {
                            int index = list.indexOf(item);
                            return GestureDetector(
                              onTap: () => showModalBottomSheet<void>(
                                  backgroundColor: Colors.white,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.95,
                                        child: ProductDetail(
                                          details: item,
                                        ));
                                  }),
                              child: Container(
                                margin:
                                    EdgeInsets.only(left: index == 0 ? 0 : 10),
                                width:
                                    MediaQuery.of(context).size.width / 2 - 45,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    border: Border.all(
                                        color: mainColor,
                                        width: 1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          "${item["Image_Name"]}",
                                          // "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 120,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${item["Name"]}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: TextButton(
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                                backgroundColor: Colors.white,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
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
                                                              0.95,
                                                      child: ProductDetail(
                                                        details: item,
                                                      ));
                                                });
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      mainColor)),
                                          child: const Text("Xem thêm",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white))),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList());
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
        Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
            const  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Ưu đãi, khuyến mãi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const TinTucScreen()));
                  //   },
                  //   child: Text(
                  //     "Xem thêm",
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w400,
                  //       color: mainColor,
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: 285,
                child: FutureBuilder(
                  future: newsModel.getCustomerNewsByGroup("Tin khuyến mãi"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView(
                          padding: const EdgeInsets.only(top: 15),
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.map((item) {
                            int index = snapshot.data!.toList().indexOf(item);
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                    backgroundColor: Colors.white,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.95,
                                          child: ChiTietTinTuc(
                                            detail: item,
                                            type: "ưu đãi, khuyến mãi",
                                          ));
                                    });
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      border: Border.all(
                                          color: mainColor,
                                          width: 1)),
                                  margin:
                                  EdgeInsets.only(left: index == 0 ? 0 : 15),
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(6)
                                            ),
                                        child: Image.network(
                                          "${item["Image"]}",
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "${item["Title"]}",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Color(0xFF212121),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(
                                                item["ModifiedDate"])),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF8B8B8B),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Html(
                                        data: item["Content"], style: {
                                          "*": Style(margin: Margins.only(left: 0, top: 0), maxLines: 2, textOverflow: TextOverflow.ellipsis),
                                          "p": Style(
                                              lineHeight: const LineHeight(1.5),
                                              fontSize: FontSize(15),
                                              fontWeight: FontWeight.w300)
                                        },
                                      )
                                    ],
                                  )),
                            );
                          }).toList(),
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 0, bottom: 10),
                              child:
                                  Image.asset("assets/images/account/img.webp"),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              child: const Text(
                                "Xin lỗi! Hiện tại Ngọc Hường chưa có ưu đãi và khuyến mãi",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
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
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Kiến thức làm đẹp",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const KienThucScreen()));
                    },
                    child: Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mainColor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 280,
                child: FutureBuilder(
                  future: newsModel.getCustomerNewsByGroup("Kiến thức làm đẹp"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView(
                          padding: const EdgeInsets.only(top: 15),
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.map((item) {
                            int index = snapshot.data!.toList().indexOf(item);
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                    backgroundColor: Colors.white,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.95,
                                          child: ChiTietTinTuc(
                                            detail: item,
                                            type: "kiến thức làm đẹp",
                                          ));
                                    });
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      border: Border.all(
                                          color: mainColor,
                                          width: 1)),
                                  margin:
                                  EdgeInsets.only(left: index == 0 ? 0 : 15),
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(6)
                                        ),
                                        child: Image.network(
                                          "${item["Image"]}",
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "${item["Title"]}",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Color(0xFF212121),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(
                                                item["ModifiedDate"])),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF8B8B8B),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Html(
                                        data: item["Content"],
                                        style: {
                                          "*": Style(margin: Margins.only(left: 0, top: 0), maxLines: 2, textOverflow: TextOverflow.ellipsis),
                                          "p": Style(
                                              lineHeight: const LineHeight(1.5),
                                              fontSize: FontSize(15),
                                              fontWeight: FontWeight.w300)
                                        },
                                      )
                                    ],
                                  )),
                            );
                          }).toList(),
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 0, bottom: 10),
                              child:
                              Image.asset("assets/images/account/img.webp"),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              child: const Text(
                                "Xin lỗi! Hiện tại Ngọc Hường chưa có ưu đãi và khuyến mãi",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
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
              )
            ],
          ),
        ),
        SizedBox(height: 25,)
      ],
    ),
  );
}
