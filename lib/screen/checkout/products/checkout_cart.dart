import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/quan_li_dia_chi.dart';
import 'package:ngoc_huong/screen/checkout/checkout_success.dart';
import 'package:ngoc_huong/screen/checkout/products/modal_payment.dart';
import 'package:ngoc_huong/screen/checkout/products/modal_voucher.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class CheckOutCart extends StatefulWidget {
  final num total;
  final List listCart;
  const CheckOutCart({super.key, required this.total, required this.listCart});

  @override
  State<CheckOutCart> createState() => _CheckOutScreenState();
}

int diem = 0;

class _CheckOutScreenState extends State<CheckOutCart> {
  LocalStorage storage = LocalStorage("auth");
  @override
  Widget build(BuildContext context) {
    List listProductPayment = widget.listCart;
    void showAlertDialog(BuildContext context, String err) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () => Navigator.pop(context, 'OK'),
      );
      AlertDialog alert = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            return SizedBox(
              // height: 30,
              width: MediaQuery.of(context).size.width,
              child: Text(
                style: const TextStyle(height: 1.6),
                err,
              ),
            );
          },
        ),
        actions: [
          okButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    void savePayment() {
      setState(() {});
    }

    void checkPay(List list, String maKh) async {
      List detail = [];
      List listId = [];
      for (var i = 0; i < list.length; i++) {
        detail.add({
          "ton00": 0,
          "ma_vt": list[i]["ma_vt"],
          "tien_hang_nt": list[i]["tien_hang_nt"],
          "tien_hang": list[i]["tien_hang"],
          "sl_xuat": list[i]["sl_xuat"],
          "sl_order": 1,
          "tien_ck_nt": list[i]["tien_ck_nt"],
          "tien_ck": list[i]["tien_ck"],
          "tien_nt": list[i]["tien_nt"],
          "tien": list[i]["tien"],
          "ma_dvt": list[i]["ma_dvt"],
        });
        listId.add(list[i]["_id"]);
      }
      Map data = {
        "ma_ct": "pbl",
        "trang_thai": 0,
        "ma_kh": maKh,
        "ma_kho": "",
        "details": detail
      };

      await postPBL(data).then((value) {
        for (var i = 0; i < listId.length; i++) {
          deleteCart(listId[i]);
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CheckoutSuccess()));
      });
    }

    void onLoading(List list, String maKh) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        checkPay(list, maKh);
        Navigator.pop(context);
      });
    }

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      // bottomNavigationBar: const MyBottomMenu(
      //   active: 1,
      // ),
      appBar: AppBar(
        // bottomOpacity: 0.0,
        elevation: 0.0,
        leadingWidth: 40,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.west,
            size: 24,
            color: Colors.black,
          ),
        ),
        title: const Text("Thanh toán",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ),
      drawer: const MyLeftMenu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: const Text("Thông tin",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
                Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 25),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset:
                              const Offset(4, 4), // changes position of shadow
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
                                future: getProfile(storage.getItem("phone")),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data![0]["ten_kh"],
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
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
                              future: getProfile(storage.getItem("phone")),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data![0]["of_user"],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
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
                                child: FutureBuilder(
                                  future: getAddress(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List list = snapshot.data!.toList();
                                      if (list.isNotEmpty) {
                                        return Text(
                                          "${list[0]["address"]}, ${list[0]["ward"]}, ${list[0]["district"]}, ${list[0]["city"]}",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        );
                                      } else {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuanLiDiaChi()));
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Thêm địa chỉ",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ))
                          ],
                        )
                      ],
                    )),
                Column(
                    children: listProductPayment.map((item) {
                  int index = listProductPayment.indexOf(item);
                  return Container(
                      margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: index != 0 ? 20 : 30,
                          bottom:
                              index == listProductPayment.length - 1 ? 20 : 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      height: 156,
                      child: FutureBuilder(
                        future: callProductApiByName(item["ten_vt"]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return TextButton(
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.95,
                                        child: ProductDetail(
                                          details: snapshot.data![0],
                                        ),
                                      );
                                    });
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 8)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Container(
                                        // color: checkColor(index),
                                        child: Image.network(
                                          "$apiUrl${item["picture"]}?$token",
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        children: [
                                          Text(
                                            snapshot.data![0]!["ten_vt"],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 8, bottom: 12),
                                              child: Html(
                                                  style: {
                                                    "*": Style(
                                                        margin: Margins.only(
                                                            top: 0, left: 0),
                                                        maxLines: 2,
                                                        fontSize: FontSize(14),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis),
                                                  },
                                                  data: snapshot
                                                      .data![0]!["mieu_ta"])),
                                          Row(
                                            children: [
                                              Text(
                                                "${item["sl_xuat"]}",
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              const Text("x"),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                NumberFormat.currency(
                                                        locale: "vi_VI",
                                                        symbol: "đ")
                                                    .format(snapshot.data![0]![
                                                        "gia_ban_le"]),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ));
                }).toList()),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset:
                              const Offset(4, 4), // changes position of shadow
                        ),
                      ]),
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 8)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset:
                              const Offset(4, 4), // changes position of shadow
                        ),
                      ]),
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 8)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
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
                    offset: const Offset(4, 4), // changes position of shadow
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
                    child: FutureBuilder(
                      future: getProfile(storage.getItem("phone")),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map profile = snapshot.data![0];
                          return FutureBuilder(
                            future: getAddress(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List address = snapshot.data!.toList();
                                return TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 20)),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.4))),
                                    onPressed: () {
                                      if (address.isEmpty) {
                                        showAlertDialog(context,
                                            "Bạn chưa thêm địa chỉ giao hàng");
                                      } else if (activePayment.isNotEmpty) {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                              content: Builder(
                                                builder: (context) {
                                                  return SizedBox(
                                                      // height: 30,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.info,
                                                            size: 70,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          const Text(
                                                            "Đặt hàng",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          const Text(
                                                            "Bạn có chắc chắn tiến hàng đặt hàng không?",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          )
                                                        ],
                                                      ));
                                                },
                                              ),
                                              actionsPadding:
                                                  const EdgeInsets.only(
                                                      top: 0,
                                                      left: 30,
                                                      right: 30,
                                                      bottom: 30),
                                              actions: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      onLoading(
                                                          listProductPayment,
                                                          profile["ma_kh"]);
                                                    },
                                                    style: ButtonStyle(
                                                        padding:
                                                            MaterialStateProperty.all(
                                                                const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        15)),
                                                        shape: MaterialStateProperty.all(
                                                            const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            15)))),
                                                        backgroundColor:
                                                            MaterialStateProperty.all(
                                                                Theme.of(context)
                                                                    .colorScheme
                                                                    .primary)),
                                                    child: const Text(
                                                      "Đồng ý",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  child: TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    style: ButtonStyle(
                                                      padding: MaterialStateProperty
                                                          .all(const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 15)),
                                                      shape: MaterialStateProperty.all(
                                                          const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              15)),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1))),
                                                    ),
                                                    child: const Text("Hủy bỏ"),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      } else {
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
                                    ));
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
