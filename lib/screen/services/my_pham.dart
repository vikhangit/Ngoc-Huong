import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class MyPhamScreen extends StatefulWidget {
  const MyPhamScreen({super.key});

  @override
  State<MyPhamScreen> createState() => _MyPhamScreenState();
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

String idProduct = "64784ee4706fa019e673a722";

List listDeXuat = [
  {
    "img": "assets/images/Services/MyPham/DeXuat/img1.png",
    "title": "Tinh chất trắng da",
    "price": "500.000"
  },
  {
    "img": "assets/images/Services/MyPham/DeXuat/img2.png",
    "title": "Serum đặc trị mụn",
    "price": "500.000"
  },
  {
    "img": "assets/images/Services/MyPham/DeXuat/img3.png",
    "title": "Tinh chất trắng da",
    "price": "500.000"
  },
  {
    "img": "assets/images/Services/MyPham/DeXuat/img4.png",
    "title": "Huyết thanh trị nám-trắng da (15ml)",
    "price": "500.000"
  },
  {
    "img": "assets/images/Services/MyPham/DeXuat/img5.png",
    "title": "Tinh chất phục hồi và chống lão hóa (3x10ml)",
    "price": "500.000"
  },
  {
    "img": "assets/images/Services/MyPham/DeXuat/img6.png",
    "title": "Kem trị nám SPF 20 (50ml)",
    "price": "500.000"
  },
];

class _MyPhamScreenState extends State<MyPhamScreen> {
  @override
  void dispose() {
    idProduct = "64784ee4706fa019e673a722";
    super.dispose();
  }

  void goToAction(String cate) {
    setState(() {
      idProduct = cate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: const MyBottomMenu(
        active: 0,
      ),
      appBar: AppBar(
        centerTitle: true,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
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
        title: const Text("Mỹ Phẩm",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ),
      drawer: const MyLeftMenu(),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 15,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0))))),
                        onPressed: () {
                          goToAction(item["category"]);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ))
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .7,
                height: MediaQuery.of(context).size.height - 200,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: callProductApi(idProduct),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Wrap(
                            runSpacing: 15,
                            spacing: 15,
                            children: snapshot.data!.map((item) {
                              int index = snapshot.data!.indexOf(item);
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(4,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                            .7 /
                                            2 -
                                        8,
                                    height: 210,
                                    child: TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 0)),
                                          backgroundColor: MaterialStateProperty
                                              .all(Colors.white),
                                          shape: MaterialStateProperty.all(
                                              const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              6))))),
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
                                                  details: item,
                                                ),
                                              );
                                            });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(6)),
                                            child: Image.network(
                                              "$apiUrl${item["picture"]}?$token",
                                              // width: 90,
                                              // height: 90,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 7),
                                            child: Flexible(
                                                child: Text(
                                              item["ten_vt"],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            )),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 7),
                                            child: Row(
                                              children: [
                                                Text(
                                                  NumberFormat.currency(
                                                          locale: "vi_VI",
                                                          symbol: "")
                                                      .format(
                                                    item["gia_ban_le"],
                                                  ),
                                                  style: const TextStyle(
                                                      // color: checkColorText(index),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const Text(
                                                  "đ",
                                                  style: TextStyle(
                                                    // color: checkColorText(index),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 5,
                                      right: 5,
                                      width: 25,
                                      height: 25,
                                      child: TextButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.all(0))),
                                        onPressed: () {
                                          print("likes");
                                        },
                                        child: const Icon(
                                          Icons.favorite_border_outlined,
                                          size: 20,
                                          // color: checkColorText(index),
                                        ),
                                      ))
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
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
          )),
    ));
  }
}
