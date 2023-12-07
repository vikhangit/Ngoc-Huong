import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/screen/cart/cart_success.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class Cosmetic extends StatefulWidget {
  final List listTab;
  const Cosmetic({super.key, required this.listTab});

  @override
  State<Cosmetic> createState() => _CosmeticState();
}

List listAction = [];

String showIndex = "";
String activeCode = listAction[0]["code"];

class _CosmeticState extends State<Cosmetic> {
  final ProductModel productModel = ProductModel();
  final CustomModal customModal = CustomModal();
  final CartModel cartModel = CartModel();
  final ScrollController scrollController = ScrollController();
  final LocalStorage storageToken = LocalStorage("customer_token");

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    setState(() {
      showIndex = "";
      listAction.clear();
    });
    setState(() {
      widget.listTab.map((e) {
        if (e["GroupCode"] != "GDC") {
          // if (e["GroupCode"].toString().contains("làm trắng")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/lam-trang.png",
          //     "title": "Làm trắng",
          //     "code": e["GroupCode"]
          //   });
          // } else if (e["GroupCode"].toString().contains("dinh dưỡng cho da")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/dinh-duong-da.png",
          //     "title": "Dinh dưỡng cho da",
          //     "code": e["GroupCode"]
          //   });
          // } else if (e["GroupCode"].toString().contains("nâng cơ")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/nang-co.png",
          //     "title": "Nâng cơ - Giảm nhăn",
          //     "code": e["GroupCode"]
          //   });
          // } else if (e["GroupCode"].toString().contains("dành cho mắt")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/danh-cho-mat.png",
          //     "title": "Dành cho mắt",
          //     "code": e["GroupCode"]
          //   });
          // } else if (e["GroupCode"]
          //     .toString()
          //     .contains("nuôi dưỡng và phục hồi da")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/nuoi-duong.png",
          //     "title": "Nuôi dưỡng và phục hồi",
          //     "code": e["GroupCode"]
          //   });
          // } else if (e["GroupCode"].toString().contains("dành cho da mụn")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/nuoi-duong.png",
          //     "title": "Nuôi dưỡng và phục hồi",
          //     "code": e["GroupCode"]
          //   });
          // } else if (e["GroupCode"].toString().contains("dành cho da mụn")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/da-mun.png",
          //     "title": "Dành cho da mụn",
          //     "code": e["GroupCode"]
          //   });
          // } else if (e["GroupCode"].toString().contains("dành cho dưỡng môi")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/duong-moi.png",
          //     "title": "Dưỡng môi",
          //     "code": e["GroupCode"]
          //   });
          // } else if (e["GroupCode"].toString().contains("dành cho dưỡng môi")) {
          //   listAction.add({
          //     "img": "assets/images/Services/MyPham/Icon/lam-sach.png",
          //     "title": "Làm sạch",
          //     "code": e["GroupCode"]
          //   });
          // }
          listAction.add(e);
        }
      }).toList();
      activeCode = listAction[0]["GroupCode"];
    });
  }

  @override
  void dispose() {
    super.dispose();
    showIndex = "";
    scrollController.dispose();
  }

  void addToCart(Map item) async {
    // customModal.showAlertDialog(context, "error", "Giỏ hàng",
    //     "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
    //   Navigator.pop(context);
    //   EasyLoading.show(status: "Vui lòng chờ...");
    //   Future.delayed(const Duration(seconds: 2), () {
    //     cartModel.addProductToCart({"quantity": 1, ...item}).then((value) {
    //       EasyLoading.dismiss();
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => const AddCartSuccess()));
    //     });
    //   });
    // }, () => Navigator.pop(context));

    Map data = {
      "DetailList": [
        {
          "Amount": item["PriceOutbound"] * 1,
          "Price": item["PriceOutbound"],
          "ProductCode": item["Code"],
          "ProductId": item["Id"],
          "Quantity": 1,
        }
      ]
    };
    customModal.showAlertDialog(context, "error", "Giỏ hàng",
        "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
      Navigator.pop(context);
      EasyLoading.show(status: "Vui lòng chờ...");
      Future.delayed(const Duration(seconds: 2), () {
        cartModel.addToCart(data).then((value) {
          print(value);
          EasyLoading.dismiss();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCartSuccess()));
        });
      });
    }, () => Navigator.pop(context));
  }

  void goToAction(String code) {
    setState(() {
      activeCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: 100,
                child: const MyBottomMenu(
                  active: 3,
                )),
            appBar: AppBar(
              primary: false,
              elevation: 0.0,
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
              title: const Text("Mỹ phẩm",
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
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 5,
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            width: MediaQuery.of(context).size.width * .3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DANH MỤC",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: mainColor),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 250,
                                  child: ListView(
                                    children: [
                                      Column(
                                        children: listAction.map((item) {
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(top: 2),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: activeCode ==
                                                            item["GroupCode"]
                                                        ? const BorderSide(
                                                            width: 3,
                                                            color: Colors.red)
                                                        : BorderSide.none)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 45,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets.symmetric(
                                                              vertical: 0,
                                                              horizontal: 2)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          activeCode == item["GroupCode"]
                                                              ? Colors.white
                                                              : Colors
                                                                  .red[100]),
                                                  shape: MaterialStateProperty.all(
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(0))))),
                                              onPressed: () {
                                                goToAction(item["GroupCode"]);
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                      child: Text(
                                                    "${item["GroupName"].toString()[0].toUpperCase()}${item["GroupName"].toString().substring(1).toLowerCase()}",
                                                    style: const TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )),
                                                  const Icon(
                                                    Icons.keyboard_arrow_right,
                                                    size: 18,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      Column(
                                        children: List.generate(
                                          5,
                                          (index) => Container(
                                            margin:
                                                const EdgeInsets.only(top: 2),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: Colors.red[100]),
                                            height: 45,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .7 - 10,
                          height: MediaQuery.of(context).size.height - 250,
                          child: ListView(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // controller: scrollController,
                            children: [
                              FutureBuilder(
                                future:
                                    productModel.getProductByGroup(activeCode),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List list = snapshot.data!.toList();
                                    return Wrap(
                                        // runSpacing: 8,
                                        alignment: WrapAlignment.spaceBetween,
                                        children: list.map((item) {
                                          return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetail(
                                                              details: item,
                                                              detailPage: true,
                                                            )));
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  .7 /
                                                                  2 -
                                                              10,
                                                      height: 230,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 2,
                                                              right: 2,
                                                              top: 8),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    15)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset: Offset(0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 6),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  height: 120,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(15)),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.3),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            2,
                                                                        offset: Offset(
                                                                            0,
                                                                            1), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    child: Image
                                                                        .network(
                                                                      "${item["Image_Name"] ?? "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  )),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "${item["Name"]}",
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        mainColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          8)),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 2,
                                                                  offset: Offset(
                                                                      0,
                                                                      1), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                                    child:
                                                                        Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            8)),
                                                                color:
                                                                    mainColor,
                                                              ),
                                                              child: Text(
                                                                  "${NumberFormat.currency(locale: "vi_VI", symbol: "").format(item["PriceInbound"])} Đ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .amber)),
                                                            )),
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              ));
                                        }).toList());
                                  } else {
                                    return Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height -
                                                250,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: LoadingIndicator(
                                                colors: kDefaultRainbowColors,
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
                                                strokeWidth: 1,
                                                // pathBackgroundColor: Colors.black45,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Đang lấy dữ liệu")
                                          ],
                                        ));
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        )
                      ],
                    )))));
  }
}
