import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/screen/account/voucher/voucher.dart';
import 'package:ngoc_huong/screen/account/voucher/voucherBuyDetail.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_chi_tiet_booking.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class VoucherSuccess extends StatefulWidget {
  final Map details;
  final Map profile;
  const VoucherSuccess(
      {super.key, required this.details, required this.profile});

  @override
  State<VoucherSuccess> createState() => _BookingSuccessState();
}

double circleSize = 140;
double iconSize = 108;
List bookingList = [];

class _BookingSuccessState extends State<VoucherSuccess>
    with TickerProviderStateMixin {
  LocalStorage storageAuth = LocalStorage("auth");
  late AnimationController scaleController = AnimationController(
      duration: const Duration(milliseconds: 800), vsync: this);
  late Animation<double> scaleAnimation =
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(
      duration: const Duration(milliseconds: 600), vsync: this);
  late Animation<double> checkAnimation =
      CurvedAnimation(parent: checkController, curve: Curves.linear);
  final ScrollController scrollController = ScrollController();

  final BookingModel bookingModel = BookingModel();

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
    bookingModel.getBookingList().then((value) => setState(() {
          bookingList = value;
        }));
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    scrollController.dispose();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const BookingServices()));
    super.dispose();
  }

  String htlm =
      "<p>Nếu muốn thay đổi lịch hẹn bạn vui lòng gọi đến Hotline <a href='tel:1900123456'>1900123456</a> <strong>trước 1h</strong> với lịch đã hẹn trước đó</p>";

  @override
  Widget build(BuildContext context) {
    var details = widget.details;
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
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
              title: const Text("Thông báo",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: Platform.isAndroid ? 75 : 100,
                child: const MyBottomMenu(
                  active: 1,
                )),
            body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListView(
                                controller: scrollController,
                                children: [
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Center(
                                    child: Stack(
                                      children: [
                                        ScaleTransition(
                                          scale: scaleAnimation,
                                          child: Container(
                                            height: circleSize,
                                            width: circleSize,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width)),
                                                border: Border.all(
                                                    width: 3,
                                                    color: Colors.green)),
                                          ),
                                        ),
                                        SizeTransition(
                                          sizeFactor: checkAnimation,
                                          axis: Axis.horizontal,
                                          axisAlignment: -1,
                                          child: Container(
                                            height: circleSize,
                                            width: circleSize,
                                            alignment: Alignment.center,
                                            child: Icon(Icons.check,
                                                color: Colors.green,
                                                size: iconSize),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "Chúc mừng bạn đã mua voucher thành công!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Xem chi tiết",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Image.asset(
                                        "assets/images/account/voucher.png",
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VoucherBuy(
                                              profile: widget.profile)));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VoucherBuyDetail(
                                                  detail: details)));
                                }),
                          ],
                        ))))));
  }
}
