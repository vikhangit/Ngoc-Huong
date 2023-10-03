import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/account/buy_history/buy_history.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

class ModalChiTietBuy extends StatelessWidget {
  final Map product;
  final String type;
  final Function? save;
  const ModalChiTietBuy(
      {super.key, required this.product, required this.type, this.save});

  @override
  Widget build(BuildContext context) {
    DateTime getPSTTime(DateTime now) {
      tz.initializeTimeZones();
      final pacificTimeZone = tz.getLocation('Asia/Ho_Chi_Minh');

      return tz.TZDateTime.from(now, pacificTimeZone);
    }

    final ProfileModel profileModel = ProfileModel();
    List list = product["DetailList"].toList();
    num totalBooking() {
      num total = 0;
      for (var i = 0; i < list.length; i++) {
        total += list[i]["Amount"];
      }
      return total;
    }

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leadingWidth: 45,
        centerTitle: true,
        leading: GestureDetector(
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
                  color:
                      type == "thanh toán" ? Colors.green : Colors.amber[800],
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
                              const Text("Thông tin khách hàng",
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
                                          return const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                            ],
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
                                          return const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                            ],
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
                                        future: profileModel.getProfile(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!["Address"],
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            );
                                          } else {
                                            return const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                              ],
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
                                  "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
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
                                        "${item["Product"]["Name"]}",
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
                                          Text("${item["Quantity"] ?? 1}",
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
                                              item["Product"]["PriceOutbound"],
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
                                      .format(totalBooking()),
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
                                    "Vui lòng thanh toán ${NumberFormat.currency(locale: "vi_VI", symbol: "đ").format(totalBooking())} khi nhận hàng",
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
                                Text(
                                    "${product["PaymentMethod"] ?? "Thanh toán khi nhận hàng"} ",
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
                Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Mã đơn hàng",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        Text("${product["Code"]}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black))
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
                              DateFormat("dd-MM-yyyy HH:mm").format(getPSTTime(
                                  DateTime.parse(list[0]["CreatedDate"]))),
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
                                    "Thời gian $type",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  )),
                                  Text(
                                    DateFormat("dd-MM-yyyy HH:mm").format(
                                        getPSTTime(DateTime.parse(
                                            list[0]["ModifiedDate"]))),
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
                  onPressed: () {},
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
