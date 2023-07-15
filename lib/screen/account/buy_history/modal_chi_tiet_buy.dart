import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/account/buy_history/buy_history.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/quan_li_dia_chi.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalChiTietBuy extends StatelessWidget {
  final Map product;
  final String type;
  final Function? save;
  const ModalChiTietBuy(
      {super.key, required this.product, required this.type, this.save});

  @override
  Widget build(BuildContext context) {
    DateTime timea = DateTime.parse(product["date_updated"]);
    var hexColor = product["color"].replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "0xFF" + hexColor;
    }
    DateTime getPSTTime(DateTime now) {
      tz.initializeTimeZones();
      final pacificTimeZone = tz.getLocation('Asia/Ho_Chi_Minh');

      return tz.TZDateTime.from(now, pacificTimeZone);
    }

    LocalStorage storage = LocalStorage("auth");
    List list = product["details"].toList();

    void cancleOrder() async {
      Map data = {"trang_thai": "9"};
      await putPBL(product["_id"], data).then((value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const BuyHistory(
                    ac: 4,
                  ))));
      save!();
    }

    void onLoading() {
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
        cancleOrder();
        Navigator.pop(context);
      });
    }

    void showInfoDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(
              builder: (context) {
                return SizedBox(
                    // height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info,
                          size: 70,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Hủy đơn hàng",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Bạn có chắc chắn hủy đơn hàng không?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w300),
                        )
                      ],
                    ));
              },
            ),
            actionsPadding:
                const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    onLoading();
                    // Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15)),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary)),
                  child: const Text(
                    "Đồng ý",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 15)),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(color: Colors.grey, width: 1))),
                  ),
                  child: const Text("Hủy bỏ"),
                ),
              )
            ],
          );
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
        leadingWidth: 45,
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuyHistory(
                            ac: type.isEmpty
                                ? 0
                                : type == "xác nhận"
                                    ? 1
                                    : type == "vận chuyển"
                                        ? 2
                                        : type == "hoàn thành"
                                            ? 3
                                            : type == "hủy đơn"
                                                ? 4
                                                : 0,
                          )));
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
        title: const Text("Chi tiết đơn hàng",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
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
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  color: Color(int.parse(hexColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Đơn hàng ${type.isNotEmpty ? "đã ${type.replaceAll("đơn", "")}" : "chờ xác nhận"}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Cảm ơn bạn đã mua hàng tại Ngọc Hường",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Image.asset(
                        "assets/images/account/file-white.png",
                        width: 45,
                        height: 45,
                        fit: BoxFit.contain,
                      )
                    ],
                  ),
                ),
                if (type != "hủy đơn")
                  Column(
                    children: [
                      if (type != "")
                        Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/account/van-chuyen.png",
                                          width: 28,
                                          height: 28,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text("Thông tin vận chuyển",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: TextButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3,
                                                          horizontal: 5))),
                                          onPressed: () {},
                                          child: const Text(
                                            "Xem",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          )),
                                    )
                                  ],
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 20, bottom: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Nhanh",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    const Text(
                                      "JT-Express",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "Đơn hàng ${type == "hoàn thành" ? "đã giao thành công" : type == "xác nhận" ? "đã đến đơn vị vận chuyển" : type == "vận chuyển" ? "đang giao" : ""}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.green),
                                        ))
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/account/dia-chi.png",
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("Địa chỉ nhận hàng",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black))
                            ],
                          )),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      future:
                                          getProfile(storage.getItem("phone")),
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    future:
                                        getProfile(storage.getItem("phone")),
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ))
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
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
                      Column(
                          children: list.map((item) {
                        int index = list.indexOf(item);
                        return Container(
                          margin: EdgeInsets.only(top: index != 0 ? 10 : 0),
                          padding: EdgeInsets.only(top: index != 0 ? 10 : 0),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: index != 0
                                      ? const BorderSide(
                                          width: 1, color: Colors.grey)
                                      : BorderSide.none)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Image.network(
                                  "$apiUrl${item["picture"]}?$token",
                                  // width: 110,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    children: [
                                      Text(
                                        "${item["ten_vt"]}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          Text("${item["sl_xuat"]}",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text("x",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: "vi_VI",
                                                    symbol: "đ")
                                                .format(
                                              item["gia_ban_le_goc"],
                                            ),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ))
                            ],
                          ),
                        );
                      }).toList()),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                                top: BorderSide(
                                    width: 1, color: Colors.grey[400]!),
                                bottom: BorderSide(
                                    width: 1, color: Colors.grey[400]!))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Thành tiền",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: "vi_VI", symbol: "đ")
                                      .format(product["t_tien"]),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            if (type != "hủy đơn")
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Vui lòng thanh toán ${NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(product["t_tien"])} khi nhận hàng",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Colors.black),
                                  )
                                ],
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (type != "hủy đơn")
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
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
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phương thức thanh toán",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Thanh toán khi nhận hàng",
                                    style: TextStyle(
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
                Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mã đơn hàng",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        // Text("$madonhang",
                        //     style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.black))
                      ],
                    )),
                Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 20),
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
                              "Thời gian đặt hàng",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            )),
                            Text(
                              "${DateFormat("dd-MM-yyyy HH:mm").format(DateTime(product["nam"], product["thang"], product["ngay"], product["gio"]))}",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        if (type.isNotEmpty)
                          Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Thời gian ${type}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  )),
                                  Text(
                                    "${DateFormat("dd-MM-yyyy HH:mm").format(getPSTTime(timea))}",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ],
                          )
                      ],
                    )),
              ],
            ),
          ),
          if (type == "")
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  left: 15,
                  right: 15),
              child: TextButton(
                  onPressed: () {
                    showInfoDialog();
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Hủy đơn hàng",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        "assets/images/cart-white.png",
                        width: 24,
                        height: 34,
                        fit: BoxFit.contain,
                      ),
                    ],
                  )),
            )
        ],
      ),
    ));
  }
}
