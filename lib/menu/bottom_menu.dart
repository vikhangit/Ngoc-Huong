import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/gift_shop/gift_shop.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/scan_order/orderPage.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/scan_order/ratingPage.dart';
import 'package:ngoc_huong/screen/scan_order/scanQr.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';

class MyBottomMenu extends StatefulWidget {
  final int active;
  const MyBottomMenu({super.key, required this.active});

  @override
  State<MyBottomMenu> createState() => _MyBottomMenuState();
}

int selectedTab = 0;

List bottomList = [
  {"icon": "assets/images/icon/home.png", "title": "Trang chủ"},
  {"icon": "assets/images/icon/QR-fanpage.png", "title": "Quét hóa đơn"},
  {"icon": "assets/images/icon/tu-van.png", "title": "Tư vấn"},
  {"icon": "assets/images/icon/checkin.png", "title": "Nhiệm vụ nhận quà"},
  {"icon": "assets/images/telesales-black.png", "title": "Tư vấn"},
];

class _MyBottomMenuState extends State<MyBottomMenu> {
  final LocalStorage storageCustomer = LocalStorage('customer_token');
  final CustomModal customModal = CustomModal();
  final ProductModel productModel = ProductModel();
  final ProfileModel profileModel = ProfileModel();
  final CartModel cartModel = CartModel();
  final ServicesModel servicesModel = ServicesModel();

  Future<void> scanBarcodeNormal() async {
    String barCodeScanRes;
    try {
      barCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barCodeScanRes = "Fail to get platform version.";
    }
    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RatingPage(item: barCodeScanRes)));
  }

  Future<void> scanQR() async {
    String barCodeScanRes;
    try {
      barCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
    } on PlatformException {
      barCodeScanRes = "Fail to get platform version.";
    }
    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RatingPage(item: barCodeScanRes)));
  }

  @override
  void initState() {
    setState(() {
      selectedTab = widget.active;
    });

    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedTab = index;
    });
    {
      if (index == 0 || index == 2) {
        switch (index) {
          case 0:
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            callBack: () {
                              setState(() {});
                            },
                          )));
              break;
            }
          case 2:
            {
              customModal.showBottomToolDialog(context);
              break;
            }
          default:
        }
      } else {
        if (storageCustomer.getItem("customer_token") != null) {
          switch (index) {
            case 1:
              {
                // scanQR();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ScanQR()));
                break;
              }
            case 3:
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GiftShop()));
                break;
              }
            case 4:
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountScreen()));
                break;
              }
            default:
          }
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const LoginScreen())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black38,
              blurRadius: 10.0,
              offset: Offset(0.0, 0.75))
        ],
      ),
      height: 100,
      child: Wrap(
        direction: Axis.vertical,
        verticalDirection: VerticalDirection.up,
        runAlignment: WrapAlignment.spaceEvenly,
        runSpacing: 15,
        children: bottomList.map((e) {
          int index = bottomList.indexOf(e);
          if (index == 4) {
            if (storageCustomer.getItem("customer_token") != null) {
              return Container(
                  // margin: EdgeInsets.only(
                  //     left: index == 2 ? 60 : 0, right: index == 1 ? 30 : 0),

                  alignment: Alignment.center,
                  child: TextButton(
                      style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0))),
                      onPressed: () => onItemTapped(index),
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: profileModel.getProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircleAvatar(
                                      backgroundColor: const Color(0xff00A3FF),
                                      backgroundImage: NetworkImage(
                                        snapshot.data["CustomerImage"],
                                      ),
                                    ));
                              } else {
                                return const SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: LoadingIndicator(
                                    colors: kDefaultRainbowColors,
                                    indicatorType: Indicator.lineSpinFadeLoader,
                                    strokeWidth: 1,
                                    // pathBackgroundColor: Colors.black45,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Tài khoản",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: widget.active == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black),
                          )
                        ],
                      )));
            } else {
              return Container(
                width: MediaQuery.of(context).size.width / 5,
                alignment: Alignment.center,
                child: TextButton(
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0))),
                    onPressed: () => onItemTapped(index),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/icon/profile-red.png",
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Tài khoản",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: widget.active == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.black),
                        )
                      ],
                    )),
              );
            }
          } else {
            return Container(
              alignment: Alignment.center,
              child: GestureDetector(
                  // style: ButtonStyle(
                  //     padding: WidgetStateProperty.all(
                  //         const EdgeInsets.symmetric(
                  //             vertical: 0.0, horizontal: 0.0))),
                  onTap: () => onItemTapped(index),
                  child: Column(
                    children: [
                      Image.asset(
                        e["icon"],
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${e["title"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: widget.active == index
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black),
                      )
                    ],
                  )),
            );
          }
        }).toList(),
      ),
    );
  }
}
