import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/checkout/checkout_success.dart';

class CheckOutStep2 extends StatefulWidget {
  const CheckOutStep2({super.key});

  @override
  State<CheckOutStep2> createState() => _CheckOutStep2State();
}

class _CheckOutStep2State extends State<CheckOutStep2> {
  @override
  Widget build(BuildContext context) {
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
        title: const Text("Xác nhận thanh toán",
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
                          children: const [
                            Expanded(
                              child: Text(
                                "Tên khách hàng",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Phương Nhi",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
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
                          children: const [
                            Expanded(
                                child: Text(
                              "Số điện thoại",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            )),
                            Expanded(
                              child: Text(
                                "0378759723",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
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
                          children: const [
                            Expanded(
                                flex: 30,
                                child: Text(
                                  "Chi nhánh",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )),
                            Expanded(
                                flex: 70,
                                child: Text(
                                  "199 Phan Đăng Lưu, phường 1, Quận Phú Nhuận",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
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
                          children: const [
                            Expanded(
                                child: Text(
                              "Voucher",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            )),
                            Expanded(
                              child: Text(
                                "Giảm 15%",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
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
                          children: const [
                            Expanded(
                                flex: 70,
                                child: Text(
                                  "Phương thức thanh toán",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )),
                            Expanded(
                              flex: 30,
                              child: Text(
                                "Ngân hàng",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                Column(
                  children: List.generate(10, (index) {
                    return Container(
                      margin: EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: index != 0 ? 20 : 0,
                      ),
                      decoration: BoxDecoration(
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
                      height: 145,
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image.asset(
                                "assets/images/Services/PhunXamMay/img1.jpg",
                                width: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    const Text(
                                      "Phun xăm môi-Cấy son tươi Hàn Quốc",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: const Text(
                                          "Cấy son tươi Hàn Quốc là phương pháp độc quyền tại Hệ thống TMV Ngọc Hường",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        )),
                                    Text(
                                      "899.000đ",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    );
                  }),
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
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Tổng giỏ hàng:",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "899.000đ",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Tiền giảm:",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "100.000đ",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
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
                      "899.000đ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 30, top: 20),
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)))),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CheckoutSuccess()));
                      },
                      child: const Text(
                        "Xác nhận",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
