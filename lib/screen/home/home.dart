import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
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
  {"icon": "assets/images/lich-da-hen.png", "title": "Lịch đã hẹn"},
  {"icon": "assets/images/Home/Icon/history.png", "title": "Lịch sử làm đẹp"},
  {
    "icon": "assets/images/Home/Icon/membership.png",
    "title": "Hạng thành viên"
  },
  {"icon": "assets/images/Home/Icon/uu-dai.png", "title": "Ưu đãi"},
  // {"icon": "assets/images/Home/Icon/dich-vu.png", "title": "Dịch vụ"},
  // {"icon": "assets/images/Home/Icon/vi.png", "title": "Điểm"},
  // {"icon": "assets/images/list-order.png", "title": "Lịch sử mua hàng"},
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookingHistory(
                      ac: 0,
                    )));
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
            customModal.showAlertDialog(
                context,
                "error",
                "Xin Lỗi Quý Khách",
                "Chúng tôi đang nâng cấp tính năng này",
                    () => Navigator.pop(context),
                    () => Navigator.pop(context));
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
    print(storageCustomerToken.getItem("customer_token"));
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: const MyBottomMenu(
          active: 0,
        ),
        appBar: null,
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
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final ProfileModel profileModel = ProfileModel();
  final CartModel cartModel = CartModel();
  final BookingModel bookingModel = BookingModel();
  return SizedBox(
    child: Column(
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
              Positioned(
                bottom: 0,
                left: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5, color: Colors.black38))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            storageCustomerToken.getItem("customer_token") !=
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
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
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
                                                      const Color(0xff00A3FF),
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
                                                const Text(
                                                  "Hi!",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  "${profile["CustomerName"]}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
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
                                            indicatorType:
                                                Indicator.lineSpinFadeLoader,
                                            strokeWidth: 1,
                                            // pathBackgroundColor: Colors.black45,
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
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
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )),
                                  ),
                            Row(
                              children: [
                                FutureBuilder(
                                  future: cartModel.getProductCartList() ,
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData){
                                      return badges.Badge(
                                        position: badges.BadgePosition.topEnd(top: -8, end: 2),
                                        showBadge: true,
                                        ignorePointer: false,
                                        onTap: () {
                                          if(storageCustomerToken.getItem("customer_token") != null){
                                            Navigator.push(context, MaterialPageRoute(builder: (contex) => CartScreen()));
                                          }else{
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const LoginScreen()));
                                          }
                                        },
                                        badgeContent:
                                        Text("${snapshot.data!.length}", style: TextStyle(fontSize: 8, color: Colors.white),),
                                        badgeAnimation: badges.BadgeAnimation.rotation(
                                          animationDuration: Duration(seconds: 1),
                                          colorChangeAnimationDuration: Duration(seconds: 1),
                                          loopAnimation: false,
                                          curve: Curves.fastOutSlowIn,
                                          colorChangeAnimationCurve: Curves.easeInCubic,
                                        ),

                                        child: Container(
                                          margin: const EdgeInsets.only(right: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              if(storageCustomerToken.getItem("customer_token") != null){
                                                Navigator.push(context, MaterialPageRoute(builder: (contex) => CartScreen()));
                                              }else{
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => const LoginScreen()));
                                              }
                                            },
                                            child: Image.asset(
                                              "assets/images/shopping-cart.png",
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    else{
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
                                      if(snapshot.hasData){
                                       return badges.Badge(
                                          position: badges.BadgePosition.topEnd(top: -8, end: 2),
                                          showBadge: true,
                                          ignorePointer: false,
                                         onTap: () {
                                           if(storageCustomerToken.getItem("customer_token") != null) {
                                             Navigator.push(
                                                 context,
                                                 MaterialPageRoute(
                                                     builder: (context) =>
                                                     const NotificationScreen()));
                                           }else{
                                             Navigator.push(context,
                                                 MaterialPageRoute(builder: (context) => const LoginScreen()));
                                           }
                                         },
                                          badgeContent:
                                          Text("${snapshot.data!.length}", style: TextStyle(fontSize: 8, color: Colors.white),),
                                          badgeAnimation: badges.BadgeAnimation.rotation(
                                            animationDuration: Duration(seconds: 1),
                                            colorChangeAnimationDuration: Duration(seconds: 1),
                                            loopAnimation: false,
                                            curve: Curves.fastOutSlowIn,
                                            colorChangeAnimationCurve: Curves.easeInCubic,
                                          ),

                                          child: Container(
                                            margin: const EdgeInsets.only(right: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                if(storageCustomerToken.getItem("customer_token") != null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                          const NotificationScreen()));
                                                }else{
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                                                }
                                              },
                                              child: Image.asset(
                                                "assets/images/notification-solid-black.png",
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      else{
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
                              width: MediaQuery.of(context).size.width / 5 - 18,
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
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1, color: mainColor)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 6),
                                      child: Image.asset(
                                        width: 35,
                                        height: 35,
                                        "${item["icon"]}",
                                        fit: BoxFit.fill,
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
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFfed766),
            gradient: LinearGradient(
                colors: [Colors.amber, mainColor],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ĐĂNG KÝ THÀNH VIÊN",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5,),
              Text(
                "Nhận ngay voucher làm đẹp 100.000đ và rất nhiều quà tặng",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
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
                    "DỊCH VỤ NỔI BẬT",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
                    child: const Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
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
                                                0.85,
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
                                    border:
                                        Border.all(color: mainColor, width: 1)),
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
                                                              0.85,
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
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "SẢN PHẨM BÁN CHẠY",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
                    child: const Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 15,
              ),
              SizedBox(
                height: 190,
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
                                                0.85,
                                        child: ProductDetail(
                                          details: item,
                                        ));
                                  }),
                              child: Container(
                                margin:
                                    EdgeInsets.only(left: index == 0 ? 0 : 5),
                                width:
                                    MediaQuery.of(context).size.width / 3 - 10,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    border:
                                        Border.all(color: mainColor, width: 1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                              fontSize: 10,
                                              height: 1.3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "đ",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                  locale: "vi_VI", symbol: "")
                                                  .format(
                                                item["CustomerPrice"] ??
                                                    item["PriceInbound"] ??
                                                    0,
                                              ),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "-5%",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.amber),
                                        ),
                                      ],
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
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "KHUYẾN MÃI HOT",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TinTucScreen()));
                    },
                    child: const Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
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
                      } else {
                        return  Wrap(
                          spacing: 5,
                          runSpacing: 15,
                          children: list.sublist(0, list.length > 6 ? 6 : list.length).map((item) {
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
                                              0.85,
                                          child: ChiTietTinTuc(
                                            detail: item,
                                            type: "khuyến mãi",
                                          ));
                                    });
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width / 3 - 10,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          "${item["Image"]}",
                                          // "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                          fit: BoxFit.cover,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          height: 120,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${item["Title"]}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              height: 1.3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(height: 8,)
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
