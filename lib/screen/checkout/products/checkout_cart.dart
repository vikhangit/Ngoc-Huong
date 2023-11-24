import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/addressModel.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/checkout/checkout_success.dart';
import 'package:ngoc_huong/screen/checkout/products/modalChooseAddress.dart';
import 'package:ngoc_huong/screen/checkout/products/modal_payment.dart';
import 'package:ngoc_huong/screen/checkout/products/modal_voucher.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class CheckOutCart extends StatefulWidget {
  final num total;
  final List listCart;
  const CheckOutCart({super.key, required this.total, required this.listCart});

  @override
  State<CheckOutCart> createState() => _CheckOutScreenState();
}

int diem = 0;
String selectAddress = "";

class _CheckOutScreenState extends State<CheckOutCart> {
  final ProfileModel profileModel = ProfileModel();
  final CartModel cartModel = CartModel();
  final OrderModel orderModel = OrderModel();
  final CustomModal customModal = CustomModal();
  final ProductModel productModel = ProductModel();
  final AddressModel addressModel = AddressModel();
  final LocalStorage storageBranch = LocalStorage('branch');
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    addressModel.getCustomerAddress().then((value) => setState(() {
          int index =
              value.indexWhere((element) => element["IsDefault"] == true);
          if (index >= 0) {
            activeIndex = index;
            selectAddress =
                "${value[index]["ApartmentNumber"]}, ${value[index]["WardName"]}, ${value[index]["DistrictName"]}, ${value[index]["ProvinceName"]}";
          } else {
            activeIndex = -1;
            selectAddress = "";
          }
        }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List listProductPayment = widget.listCart;
    void savePayment() {
      setState(() {});
    }

    void setCheckOutCart() {
      if (selectAddress.isNotEmpty) {
        List details = [];
        List idList = [];
        for (var i = 0; i < listProductPayment.length; i++) {
          details.add({
            "Amount": listProductPayment[i]["Amount"],
            "Price": listProductPayment[i]["Amount"] /
                listProductPayment[i]["Quantity"],
            "Quantity": listProductPayment[i]["Quantity"],
            "ProductId": listProductPayment[i]["ProductId"],
          });
          idList.add(listProductPayment[i]["Id"]);
        }
        Map data = {
          "Address": selectAddress,
          "TotalAmount": widget.total,
          "BranchName": storageBranch.getItem("branch") == null
              ? ""
              : jsonDecode(storageBranch.getItem("branch"))["Name"],
          "DetailList": [...details]
        };
        customModal.showAlertDialog(
            context, "error", "Đặt Hàng", "Bạn có chắc chắn đăt hàng không?",
            () {
          Navigator.pop(context);
          EasyLoading.show(status: "Vui lòng chờ...");
          Future.delayed(const Duration(seconds: 2), () {
            for (var i = 0; i < listProductPayment.length; i++) {
              cartModel.updateProductInCart({
                // "Id": 1,
                "DetailList": [
                  {...listProductPayment[i], "IsDeleted": true}
                ]
              }).then((value) => setState(() {}));
            }
            orderModel.setOrder(data).then((value) {
              EasyLoading.dismiss();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CheckoutSuccess()));
            });
          });
        }, () => Navigator.pop(context));
      } else {
        customModal.showAlertDialog(
            context, "error", "Đặt Hàng", "Bạn chưa chọn địa chỉ giao hàng",
            () {
          Navigator.pop(context);
        }, () {
          Navigator.pop(context);
        });
      }
    }

    return SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
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
            title: const Text("Thanh toán",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          bottomNavigationBar: ScrollToHide(
              scrollController: scrollController,
              height: 100,
              child: const MyBottomMenu(
                active: -1,
              )),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: const Text("Thông tin",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(
                                  4, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Tên khách hàng",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: FutureBuilder(
                                    future: profileModel.getProfile(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data!["CustomerName"],
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        );
                                      } else {
                                        return const SizedBox(
                                          width: 40,
                                          height: 40,
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
                                )
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                    child: Text(
                                  "Số điện thoại",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )),
                                Expanded(
                                    child: FutureBuilder(
                                  future: profileModel.getProfile(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!["Phone"],
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      );
                                    } else {
                                      return const SizedBox(
                                        width: 40,
                                        height: 40,
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
                                ))
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                    flex: 30,
                                    child: Text(
                                      "Địa chỉ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    )),
                                Expanded(
                                    flex: 70,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (selectAddress.isNotEmpty)
                                          Text(
                                            selectAddress,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        Container(
                                          // width: 15,
                                          margin: EdgeInsets.only(top: 5),
                                          height: 20,
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets.all(
                                                            0.0))),
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.88,
                                                        child: ChooseAddressShipping(
                                                            saveAddress: () =>
                                                                setState(
                                                                    () {})));
                                                  });
                                            },
                                            child: Text(
                                              selectAddress.isNotEmpty
                                                  ? "Thay đổi"
                                                  : "Thêm",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: mainColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ],
                        )),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => ChooseAddressShipping(
                    //                   saveAddress: saveAddress,
                    //                 )));
                    //   },
                    //   child: Container(
                    //       margin: const EdgeInsets.only(
                    //           left: 15, right: 15, top: 10, bottom: 25),
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 15, vertical: 20),
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius:
                    //             const BorderRadius.all(Radius.circular(14)),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(0.5),
                    //             spreadRadius: 1,
                    //             blurRadius: 8,
                    //             offset: const Offset(
                    //                 4, 4), // changes position of shadow
                    //           ),
                    //         ],
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //             flex: 9,
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 const Text(
                    //                   "Địa chỉ nhận hàng",
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.w400,
                    //                       color: Colors.black),
                    //                 ),
                    //                 FutureBuilder(
                    //                   future: getAddress(),
                    //                   builder: (context, snapshot) {
                    //                     if (snapshot.hasData) {
                    //                       List list = snapshot.data!.toList();
                    //                       if (list.isNotEmpty) {
                    //                         return activeIndex > -1
                    //                             ? Text(
                    //                                 "${list[activeIndex]["address"]}, ${list[activeIndex]["ward"]}, ${list[activeIndex]["district"]}, ${list[activeIndex]["city"]}",
                    //                                 style: const TextStyle(
                    //                                     fontWeight: FontWeight.w400,
                    //                                     color: Colors.black),
                    //                               )
                    //                             : Column(
                    //                                 children: list.map((e) {
                    //                                   if (e["exfields"]
                    //                                           ["is_default"] ==
                    //                                       true) {
                    //                                     return Text(
                    //                                       "${e["address"]}, ${e["ward"]}, ${e["district"]}, ${e["city"]}",
                    //                                       style: const TextStyle(
                    //                                           fontWeight:
                    //                                               FontWeight.w400,
                    //                                           color: Colors.black),
                    //                                     );
                    //                                   } else {
                    //                                     return Container();
                    //                                   }
                    //                                 }).toList(),
                    //                               );
                    //                       } else {
                    //                         return Container();
                    //                       }
                    //                     } else {
                    //                       return const Center(
                    //                         child: CircularProgressIndicator(),
                    //                       );
                    //                     }
                    //                   },
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           Expanded(
                    //             flex: 1,
                    //             child: Icon(Icons.keyboard_arrow_right),
                    //           )
                    //         ],
                    //       )),
                    // ),

                    Column(
                        children: listProductPayment.map((item) {
                      int index = listProductPayment.indexOf(item);
                      return Container(
                          margin: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: index != 0 ? 10 : 20,
                              bottom: index == listProductPayment.length - 1
                                  ? 20
                                  : 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(
                                    4, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          height: 160,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                width: MediaQuery.of(context).size.width - 70,
                                child: FutureBuilder(
                                  future: productModel
                                      .getProductCode(item["ProductCode"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map detail = snapshot.data!;
                                      return TextButton(
                                        onPressed: () {
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
                                                      0.95,
                                                  child: ProductDetail(
                                                    details: detail,
                                                  ),
                                                );
                                              });
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 8)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all(
                                              const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)))),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: Image.network(
                                                      "${detail["Image_Name"] ?? "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                                      width: 90,
                                                      height: 90,
                                                      fit: BoxFit.cover,
                                                    )),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Wrap(
                                                      children: [
                                                        Text(
                                                          item["ProductName"],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                NumberFormat.currency(
                                                                        locale:
                                                                            "vi_VI",
                                                                        symbol:
                                                                            "đ")
                                                                    .format(item[
                                                                        "Price"]),
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  border: BorderDirectional(
                                                      top: BorderSide(
                                                          width: 1,
                                                          color: Colors
                                                              .grey[400]!),
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: Colors
                                                              .grey[400]!))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${item["Quantity"]} sản phẩm",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Thành tiền:",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        NumberFormat.currency(
                                                                locale: "vi_VI",
                                                                symbol: "đ")
                                                            .format(
                                                                item["Amount"]),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: LoadingIndicator(
                                            colors: kDefaultRainbowColors,
                                            indicatorType:
                                                Indicator.lineSpinFadeLoader,
                                            strokeWidth: 1,
                                            // pathBackgroundColor: Colors.black45,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ));
                    }).toList()),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(
                                  4, 4), // changes position of shadow
                            ),
                          ]),
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 8)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        onPressed: () {
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
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: const ModalVoucher());
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/voucher.png",
                                  width: 28,
                                  height: 28,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Voucher",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            const Row(
                              children: [
                                Text("Chọn hoặc nhập mã",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black45)),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.keyboard_arrow_right_outlined,
                                    color: Colors.black45)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   margin:
                    //       const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                    //       color: Colors.white,
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.withOpacity(0.5),
                    //           spreadRadius: 1,
                    //           blurRadius: 8,
                    //           offset:
                    //               const Offset(4, 4), // changes position of shadow
                    //         ),
                    //       ]),
                    //   child: TextButton(
                    //     style: ButtonStyle(
                    //       padding: MaterialStateProperty.all(
                    //           const EdgeInsets.symmetric(
                    //               vertical: 20, horizontal: 8)),
                    //       backgroundColor: MaterialStateProperty.all(
                    //           diem == 0 ? Colors.grey[400] : Colors.white),
                    //       shape: MaterialStateProperty.all(
                    //           const RoundedRectangleBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(10)))),
                    //     ),
                    //     onPressed: () {
                    //       if (diem == 0) {
                    //       } else {
                    //         showAlertDialog(context,
                    //             "Xin lỗi quý khách. Quý khách chưa có điểm để sử dụng");
                    //       }
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Image.asset(
                    //               "assets/images/point.png",
                    //               width: 28,
                    //               height: 28,
                    //             ),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             Text(
                    //               "Ngọc Hường - điểm",
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.w400,
                    //                   color: diem == 0
                    //                       ? Theme.of(context).colorScheme.primary
                    //                       : Colors.black),
                    //             ),
                    //             const SizedBox(
                    //               width: 5,
                    //             ),
                    //             Text("($diem điểm)",
                    //                 style: TextStyle(
                    //                     fontWeight: FontWeight.w300,
                    //                     color: diem == 0
                    //                         ? Theme.of(context)
                    //                             .colorScheme
                    //                             .primary
                    //                             .withOpacity(0.7)
                    //                         : Colors.black45)),
                    //           ],
                    //         ),
                    //         Icon(Icons.keyboard_arrow_right_outlined,
                    //             color: diem == 0
                    //                 ? Theme.of(context)
                    //                     .colorScheme
                    //                     .primary
                    //                     .withOpacity(0.7)
                    //                 : Colors.black45)
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(
                                  4, 4), // changes position of shadow
                            ),
                          ]),
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 8)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        onPressed: () {
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
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: ModalPayment(
                                      savePayment: savePayment,
                                    ));
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/thanh-toan.png",
                                  width: 28,
                                  height: 28,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Phương thức thanh toán",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(activePayment,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black45)),
                                  ],
                                )
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_right_outlined,
                                color: Colors.black45)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset:
                            const Offset(4, 4), // changes position of shadow
                      ),
                    ],
                    border: const Border(
                        top: BorderSide(width: 1, color: Colors.black12))),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng hóa đơn:",
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        Text(
                          NumberFormat.currency(locale: "vi_VI", symbol: "đ")
                              .format(widget.total),
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 30, top: 20),
                        child: TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20)),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)))),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.4))),
                            onPressed: () {
                              if (activePayment.isNotEmpty) {
                                setCheckOutCart();
                              } else {
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
                                              0.6,
                                          child: ModalPayment(
                                            savePayment: savePayment,
                                          ));
                                    });
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Container()),
                                const Expanded(
                                  flex: 8,
                                  child: Center(
                                    child: Text(
                                      "Đặt hàng",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    "assets/images/calendar-black.png",
                                    width: 40,
                                    height: 30,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              ],
                            )))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
