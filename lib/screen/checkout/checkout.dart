import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_chi_tiet_booking.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class CheckOutScreen extends StatefulWidget {
  final int total;
  const CheckOutScreen({super.key, required this.total});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  LocalStorage storage = LocalStorage("auth");
  @override
  Widget build(BuildContext context) {
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
                      ],
                    )),
                FutureBuilder(
                  future: callBookingApi(storage.getItem("phone")),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!;
                      if (snapshot.data!.isNotEmpty) {
                        return Column(
                            children: list.map((item) {
                          int index = list.indexOf(item);
                          return Container(
                            margin: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: index != 0 ? 20 : 30,
                                bottom: index == list.length - 1 ? 20 : 0),
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
                            height: 135,
                            child: FutureBuilder(
                              future: callServiceApiById(item["ten_vt"]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextButton(
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(15.0),
                                              ),
                                            ),
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
                                                  child: ModalChiTietBooking(
                                                    details: item,
                                                    details2:
                                                        snapshot.data![0]!,
                                                  ));
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: Image.network(
                                              "$apiUrl${snapshot.data![0]!["picture"]}?$token",
                                              // width: 110,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
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
                                                    "${snapshot.data![0]!["ten_vt"]}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              top: 5),
                                                      child: Html(
                                                          style: {
                                                            "*": Style(
                                                                margin: Margins
                                                                    .only(
                                                                        top: 0,
                                                                        left:
                                                                            0),
                                                                maxLines: 2,
                                                                fontSize:
                                                                    FontSize(
                                                                        14),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          },
                                                          data: snapshot.data![
                                                              0]!["mieu_ta"])),
                                                  Text(
                                                    NumberFormat.currency(
                                                            locale: "vi_VI",
                                                            symbol: "đ")
                                                        .format(
                                                      snapshot.data![0]![
                                                          "gia_ban_le"],
                                                    ),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                  )
                                                ],
                                              )
                                            ],
                                          ))
                                        ],
                                      ));
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          );
                        }).toList());
                      } else {
                        return Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Text("Chưa có dịch vụ trong giỏ hàng"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
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
                      showAlertDialog(context,
                          "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
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
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                      showAlertDialog(context,
                          "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/point.png",
                              width: 28,
                              height: 28,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Ngọc Hường - điểm",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text("(3000 điểm)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black45)),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_right_outlined,
                            color: Colors.black45)
                      ],
                    ),
                  ),
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
                      showAlertDialog(context,
                          "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
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
                            const Text(
                              "Phương thức thanh toán",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Text("Ví",
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const CheckOutStep2()));
                          showAlertDialog(context,
                              "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
                        },
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            const Expanded(
                              flex: 8,
                              child: Center(
                                child: Text(
                                  "Thanh toán",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
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
