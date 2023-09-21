import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/newsModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/cart/cart.dart';
import 'package:ngoc_huong/screen/cosmetic/cosmetic.dart';
import 'package:ngoc_huong/screen/cosmetic/special_cosmetic.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/member/thanh_vien.dart';
import 'package:ngoc_huong/screen/news/tin_tuc.dart';
import 'package:ngoc_huong/screen/services/all_service.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/news/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/screen/services/special_service.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_floating_button.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';
import 'package:ngoc_huong/utils/notification_services.dart';

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
  {"icon": "assets/images/calendar-solid-red.png", "title": "Đặt lịch"},
  {"icon": "assets/images/product-solid-red.png", "title": "Mỹ phẩm"},
  {"icon": "assets/images/logo.png", "title": "Dịch vụ"},
  {"icon": "assets/images/vi-solid-red.png", "title": "Ví"},
  {"icon": "assets/images/diem-solid-red.png", "title": "Điểm"},
  {"icon": "assets/images/gift-solid-red.png", "title": "Ưu đãi"},
  {"icon": "assets/images/history-solid-red.png", "title": "Lịch sử làm đẹp"},
  {"icon": "assets/images/call-solid-red.png", "title": "Tư vấn"},
];
bool showAppBar = false;
int current = 0;
String tokenfirebase = "";

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  NotificationService notificationService = NotificationService();
  final CarouselController controller = CarouselController();
  final ProfileModel profileModel = ProfileModel();
  final ServicesModel servicesModel = ServicesModel();
  final CustomModal customModal = CustomModal();
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final LocalStorage storageBranch = LocalStorage('branch');

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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Cosmetic()));
    } else if (index == 2) {
      servicesModel.getGroupServiceByBranch().then((value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AllServiceScreen(
                    listTab: value,
                  ))));
    } else if(index == 7){
      customModal.showAlertDialog(context, "error", "Gọi Điện Tư Vấn", "Bạn có chắc muốn gọi điện đến Ngọc Hường để nhận tư vẫn không?", () => makingPhoneCall(), () => Navigator.pop(context));
    }
    else{
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
             customModal.showAlertDialog(context, "error", "Xin Lỗi Quý Khách", "Chúng tôi đang nâng cấp tính năng này", () => Navigator.pop(context), () => Navigator.pop(context));
              break;
            }
          case 4:
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ThanhVienScreen()));
              break;
            }
          case 5:
            {
              customModal.showAlertDialog(context, "error", "Xin Lỗi Quý Khách", "Chúng tôi đang nâng cấp tính năng này", () => Navigator.pop(context), () => Navigator.pop(context));
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
          default:
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
        floatingActionButton: const CustomFloatingButton(),
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
                    margin: const EdgeInsets.only(right: 10),
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
              listView(
                  context, (context, index) => goToService(context, index)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget listView(BuildContext context,
    Function(BuildContext context, int index) goToService) {
  final ServicesModel servicesModel = ServicesModel();
  final NewsModel newsModel = NewsModel();
  final ProductModel productModel = ProductModel();
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          // height: 130,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            // scrollDirection: Axis.horizontal,
            children: toolServices.map((item) {
              int index = toolServices.indexOf(item);
              return SizedBox(
                width: MediaQuery.of(context).size.width / 4 - 10,
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
                            color: mainColor.withOpacity(0.1),
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
          margin: const EdgeInsets.only(top: 30),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                                      width:
                                      MediaQuery.of(context).size.width,
                                      child: TextButton(
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                                backgroundColor:
                                                Colors.white,
                                                clipBehavior: Clip
                                                    .antiAliasWithSaveLayer,
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery
                                                              .of(
                                                              context)
                                                              .viewInsets
                                                              .bottom),
                                                      height: MediaQuery.of(
                                                          context)
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
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                                          // "${item["Image_Name"]}",
                                          "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
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
                                      width:
                                      MediaQuery.of(context).size.width,
                                      child: TextButton(
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                                backgroundColor:
                                                Colors.white,
                                                clipBehavior: Clip
                                                    .antiAliasWithSaveLayer,
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery
                                                              .of(
                                                              context)
                                                              .viewInsets
                                                              .bottom),
                                                      height: MediaQuery.of(
                                                          context)
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
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Ưu đãi, khuyến mãi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF555555),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TinTucScreen()));
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
                // height: 250,
                child: FutureBuilder(
                  future: newsModel.getTop5CustomerNews(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 15,
                          children: snapshot.data!.map((item) {
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
                                            type: "tin tức",
                                          ));
                                    });
                              },
                              child: SizedBox(
                                  height: 205,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      22.5,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(14)),
                                        child: Image.network(
                                          "",
                                          height: 135,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "${item["title"]}",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Color(0xFF212121),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(
                                                item["date_updated"])),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF8B8B8B),
                                            fontWeight: FontWeight.w400),
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
                                "Xin lỗi! Hiện tại Ngọc Hường chưa bài viết về kiến thức làm đẹp",
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
                      color: Color(0xFF555555),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TinTucScreen()));
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
                // height: 250,
                child: FutureBuilder(
                  future: newsModel.getTop5CustomerNews(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 15,
                          children: snapshot.data!.map((item) {
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
                                            type: "tin tức",
                                          ));
                                    });
                              },
                              child: SizedBox(
                                  height: 205,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      22.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(14)),
                                        child: Image.network(
                                          "",
                                          height: 135,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "${item["title"]}",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Color(0xFF212121),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(
                                                item["date_updated"])),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF8B8B8B),
                                            fontWeight: FontWeight.w400),
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
                                "Xin lỗi! Hiện tại Ngọc Hường chưa bài viết về kiến thức làm đẹp",
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
      ],
    ),
  );
}
