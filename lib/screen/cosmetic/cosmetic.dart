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
import 'package:ngoc_huong/utils/CustomTheme/custom_floating_button.dart';

class Cosmetic extends StatefulWidget {
  const Cosmetic({super.key});

  @override
  State<Cosmetic> createState() => _CosmeticState();
}
List listAction = [
  {
    "img": "assets/images/Services/MyPham/Icon/lam-trang.png",
    "title": "Làm trắng",
    "category": "64784ee4706fa019e673a722"
  },
  {
    "img": "assets/images/Services/MyPham/Icon/duong-am.png",
    "title": "Dưỡng ẩm",
    "category": "64784ea8706fa019e673a709"
  },
  {
    "img": "assets/images/Services/MyPham/Icon/dinh-duong-da.png",
    "title": "Dinh dưỡng da",
    "category": "64785397706fa019e673aede"
  },
  {
    "img": "assets/images/Services/MyPham/Icon/nang-co.png",
    "title": "Nâng cơ - Giảm nhăn",
    "category": "647853c8706fa019e673af18"
  },
  {
    "img": "assets/images/Services/MyPham/Icon/danh-cho-mat.png",
    "title": "Dành cho mắt",
    "category": "647853da706fa019e673af54"
  },
  {
    "img": "assets/images/Services/MyPham/Icon/nuoi-duong.png",
    "title": "Nuôi dưỡng và phục hồi",
    "category": "647853ec706fa019e673af6a"
  },
  {
    "img": "assets/images/Services/MyPham/Icon/da-mun.png",
    "title": "Dành cho da mụn",
    "category": "64785427706fa019e673afa6"
  },
  {
    "img": "assets/images/Services/MyPham/Icon/duong-moi.png",
    "title": "Dưỡng môi",
    "category": "64785434706fa019e673b008"
  },
  {
    "img": "assets/images/Services/MyPham/Icon/lam-sach.png",
    "title": "Làm sạch",
    "category": "647854b2706fa019e673b0d9"
  },
];

String showIndex = "";
String idProduct = listAction[0]["category"];

class _CosmeticState extends State<Cosmetic> {
  final ProductModel productModel = ProductModel();
  final CustomModal customModal = CustomModal();
  final CartModel cartModel = CartModel();

  final LocalStorage storageToken = LocalStorage("customer_token");

  @override
  void initState() {
    super.initState();
    setState(() {
      showIndex = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    showIndex = "";
  }

  void addToCart(Map item) async {
    customModal.showAlertDialog(context, "error", "Giỏ hàng",
        "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
      Navigator.pop(context);
      EasyLoading.show(status: "Vui lòng chờ...");
      Future.delayed(const Duration(seconds: 2), () {
        cartModel.addProductToCart({"quantity": 1, ...item}).then((value) {
          EasyLoading.dismiss();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCartSuccess()));
        });
      });
    }, () => Navigator.pop(context));

    //
    // Map data = {
    //   "DetailList": [{
    //     "Amount": item["CusomterPrice"] * 1,
    //     "DCMember":0,
    //     "DCMemberAmount":0,
    //     "Description":null,
    //     "Prince": item["CusomterPrice"],
    //     // "PrinceTest": 19000000,
    //     "ProductCode":item["Code"],
    //     "ProductId": item["Id"],
    //     "ProductType":"product",
    //     "Quantity":1,
    //     "QuantitySaleReturn":null,
    //     "Status":null,
    //     "StatusTherapy":null,
    //     "Unit":null
    //   }]
    // };
    // customModal.showAlertDialog(context, "error", "Giỏ hàng",
    //     "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
    //       Navigator.pop(context);
    //       EasyLoading.show(status: "Vui lòng chờ...");
    //       Future.delayed(const Duration(seconds: 2), () {
    //         cartModel.addToCart(data).then((value) {
    //           print(value);
    //           EasyLoading.dismiss();
    //           // Navigator.push(context,
    //           //     MaterialPageRoute(builder: (context) => const AddCartSuccess()));
    //         });
    //       });
    //     }, () => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(active: 0),
            floatingActionButton: const CustomFloatingButton(),
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
            body: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width * .25,
                      child: ListView(
                        children: listAction.map((item) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    left: idProduct == item["category"]
                                        ? const BorderSide(
                                        width: 3, color: Colors.red)
                                        : BorderSide.none)),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 18, horizontal: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      idProduct == item["category"]
                                          ? Colors.red[100]
                                          : Colors.blue[100]),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))))),
                              onPressed: () {
                                // goToAction(item["category"]);
                              },
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    item["img"],
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Flexible(
                                      child: Text(
                                        item["title"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ))
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75 - 20,
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: productModel.getProductByGroup("GDC"),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List list = snapshot.data!.toList();
                                return  Wrap(
                                    runSpacing: 8,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: list.map((item) {
                                      return GestureDetector(
                                          onTap: () => setState(() {
                                            showIndex = item["Code"];
                                          }),
                                          child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      .7 /
                                                      2 -
                                                      4,
                                                  height: 245,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 6, vertical: 6),
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius
                                                          .all(Radius.circular(6)),
                                                      border:
                                                      Border.all(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                          width: 1)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Image.network(
                                                            // "${item["Image_Name"]}"
                                                            "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                                            fit: BoxFit.cover,
                                                            width:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .width,
                                                            height: 120,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${item["Name"]}",
                                                            maxLines: 3,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                FontWeight.w400),
                                                          ),

                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                        child: TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                showIndex =
                                                                item["Code"];
                                                              });
                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty
                                                                    .all(Theme.of(
                                                                    context)
                                                                    .colorScheme
                                                                    .primary)),
                                                            child: const Text(
                                                                "Xem thêm",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .white))),
                                                      )
                                                    ],
                                                  )),
                                              if (showIndex.isNotEmpty &&
                                                  showIndex == item["Code"])
                                                Positioned.fill(
                                                    child: Container(
                                                        padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(6)),
                                                            color: Colors.black
                                                                .withOpacity(0.4)),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    showIndex = "";
                                                                  });
                                                                  showModalBottomSheet<
                                                                      void>(
                                                                      backgroundColor:
                                                                      Colors.white,
                                                                      clipBehavior: Clip
                                                                          .antiAliasWithSaveLayer,
                                                                      context: context,
                                                                      isScrollControlled:
                                                                      true,
                                                                      builder:
                                                                          (BuildContext
                                                                      context) {
                                                                        return Container(
                                                                            padding: EdgeInsets.only(
                                                                                bottom: MediaQuery.of(context)
                                                                                    .viewInsets
                                                                                    .bottom),
                                                                            height: MediaQuery.of(context)
                                                                                .size
                                                                                .height *
                                                                                0.95,
                                                                            child:
                                                                            ProductDetail(
                                                                              details:
                                                                              item,
                                                                            ));
                                                                      });
                                                                },
                                                                child: Container(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical: 6,
                                                                        horizontal:
                                                                        10),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color: Colors
                                                                          .blue[500],
                                                                      borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              4)),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image.asset(
                                                                            "assets/images/eye-white.png",
                                                                            width: 18,
                                                                            height: 18),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        const Text(
                                                                          "Xem chi tiết",
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              10,
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w400),
                                                                        )
                                                                      ],
                                                                    ))),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    showIndex = "";
                                                                  });
                                                                  if (storageToken.getItem(
                                                                      "customer_token") ==
                                                                      null) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder:
                                                                                (context) =>
                                                                            const LoginScreen()));
                                                                  } else {
                                                                    addToCart(item);
                                                                  }
                                                                },
                                                                child: Container(
                                                                    margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 10),
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical: 6,
                                                                        horizontal:
                                                                        10),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(
                                                                                4)),
                                                                        color: Colors
                                                                            .blue[900]),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image.asset(
                                                                            "assets/images/cart-solid-white.png",
                                                                            width: 18,
                                                                            height: 18),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        const Text(
                                                                          "Mua hàng",
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              10,
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w400),
                                                                        )
                                                                      ],
                                                                    )))
                                                          ],
                                                        )))
                                            ],
                                          ));
                                    }).toList());
                              } else {
                                return Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height - 250,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                  )
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    )
                  ],
                ))
        ));
  }
}
