import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/home/flash_sale.dart';
import 'package:ngoc_huong/screen/home/prodouct.dart';
import 'package:ngoc_huong/screen/home/promotion.dart';
import 'package:ngoc_huong/screen/home/register.dart';
import 'package:ngoc_huong/screen/home/review.dart';
import 'package:ngoc_huong/screen/home/service.dart';
import 'package:ngoc_huong/screen/home/top.dart';
import 'package:ngoc_huong/screen/home/voucher.dart';
import 'package:ngoc_huong/screen/home/voucherTest.dart';

import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/notification_services.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends StatefulWidget {
  final Function callBack;
  const HomeScreen({super.key, required this.callBack});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

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
      setState(() {
        tokenfirebase = value;
      });
    });
    Upgrader.clearSavedSettings();

    if (Platform.isIOS) {
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      //     overlays: [SystemUiOverlay.bottom]);
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: mainColor,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    if (Platform.isIOS) {
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      //     overlays: [SystemUiOverlay.bottom]);
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: mainColor,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void goPage(index, reason) {
    activeCarousel = index;
  }

  Future someFunction() async {
    return customModal.showAlertDialog(context, "error", "Thoát ứng dụng",
        "Bạn có chắc chắn thoát ứng dụng không?", () {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }, () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    if (Platform.isIOS) {
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      //     overlays: [SystemUiOverlay.bottom]);
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: mainColor,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    print("-------------------------------------");
    print(storageCustomerToken.getItem("customer_token"));
    print("---------------------------------------");
    return SafeArea(
        bottom: false,
        top: false,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) {
              return;
            }
            return await someFunction();
          },
          child: Scaffold(
              // key: scaffoldKey,
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              bottomNavigationBar: ScrollToHide(
                  scrollController: scrollController,
                  height: Platform.isAndroid ? 75 : 100,
                  child: const MyBottomMenu(
                    active: 0,
                  )),
              appBar: Platform.isIOS
                  ? null
                  : AppBar(
                      leadingWidth: 45,
                      centerTitle: true,
                      toolbarHeight: 20,
                      automaticallyImplyLeading: false,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(0),
                        ),
                      ),
                    ),
              body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: RefreshIndicator(
                  onRefresh: () => refreshData(),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 20),
                    controller: scrollController,
                    children: [
                      const TopBanner(),
                      storageCustomerToken.getItem("customer_token") == null
                          ? const Register()
                          : Container(),
                      const VoucherTest(),
                      const FlashSale(),
                      const ServicesPage(),
                      const ProductPage(),
                      const ReviewPage(),
                      const Promotion()
                    ],
                  ),
                ),
              )),
        ));
  }
}
