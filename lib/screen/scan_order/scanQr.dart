import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/screen/scan_order/orderPage.dart';
import 'package:ngoc_huong/screen/scan_order/ratingPage.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final ScrollController scrollController = ScrollController();
  Future<void> scanQR() async {
    String barCodeScanRes;
    try {
      barCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Hủy ", true, ScanMode.QR);
    } on PlatformException {
      barCodeScanRes = "Fail to get platform version.";
    }
    if (!mounted) return;
    if (barCodeScanRes.isNotEmpty && barCodeScanRes != "-1") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RatingPage(item: barCodeScanRes)));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ScanQR()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: Platform.isAndroid ? 75 : 100,
                child: const MyBottomMenu(
                  active: 1,
                )),
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
              title: const Text("Quét Hóa Đơn",
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
                child: ListView(
                  controller: scrollController,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.5),
                      child: const Text(
                        "Quý khách vui lòng quét mã QR hoặc mã vạch có in trên hóa đơn để đánh giá về chất lượng dịch vụ của chúng tôi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 20, left: 12.5, right: 12.5, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                      EdgeInsets.only(left: 8, right: 20)),
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  shape: WidgetStateProperty.all(
                                      const RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 0.5, color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))))),
                              onPressed: () => {Navigator.of(context).pop()},
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.chevron_left,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Trở về",
                                    style: TextStyle(color: mainColor),
                                  )
                                ],
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                      EdgeInsets.only(left: 20, right: 10)),
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.blue[900])),
                              onPressed: () => {scanQR()},
                              child: const Row(
                                children: [
                                  Text(
                                    "Tiếp tục",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
