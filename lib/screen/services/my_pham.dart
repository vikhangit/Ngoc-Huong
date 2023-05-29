import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_san_pham.dart';

class MyPhamScreen extends StatefulWidget {
  const MyPhamScreen({super.key});

  @override
  State<MyPhamScreen> createState() => _MyPhamScreenState();
}

List listAction = [
  {
    "img": "assets/images/Services/MyPham/Icon/lam-trang.png",
    "title": "Làm trắng da",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/duong-am.png",
    "title": "Dưỡng ẩm",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/nang-co.png",
    "title": "Nâng cơ - Giảm nhăn",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/dinh-duong-da.png",
    "title": "Dinh dưỡng da",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/nuoi-duong.png",
    "title": "Nuôi dưỡng phục hồi",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/lam-sach.png",
    "title": "Làm sạch",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/da-mun.png",
    "title": "Dành cho da mụn",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/danh-cho-mat.png",
    "title": "Dành cho mắt",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/duong-moi.png",
    "title": "Dưỡng môi",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/duong-moi.png",
    "title": "Dưỡng môi",
  },
  {
    "img": "assets/images/Services/MyPham/Icon/duong-moi.png",
    "title": "Dưỡng môi",
  },
];

int active = 0;

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
  void goToAction(int index) {
    setState(() {
      active = index;
    });
  }

  Color checkColor(int index) {
    Color color = Colors.black;
    switch (index) {
      case 0:
        {
          return Colors.pink[50]!;
        }
      case 1:
        {
          return Colors.greenAccent[100]!;
        }
      case 2:
        {
          return Colors.lightBlue[100]!;
        }
      case 3:
        {
          return Colors.grey[300]!;
        }
      case 4:
        {
          return Colors.orangeAccent[100]!;
        }
      case 5:
        {
          return Colors.black12;
        }
      default:
        {}
    }
    return color;
  }

  Color checkColorText(int index) {
    Color color = Colors.black;
    switch (index) {
      case 0:
        {
          return Colors.pink;
        }
      case 1:
        {
          return Colors.green;
        }
      case 2:
        {
          return Colors.lightBlue[700]!;
        }
      case 3:
        {
          return Colors.grey[800]!;
        }
      case 4:
        {
          return Colors.orangeAccent[700]!;
        }
      case 5:
        {
          return Colors.black54;
        }
      default:
        {}
    }
    return color;
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
                    int index = listAction.indexOf(item);
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: active == index
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
                                active == index
                                    ? Colors.red[100]
                                    : Colors.blue[100]),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0))))),
                        onPressed: () {
                          goToAction(index);
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
                    Wrap(
                      runSpacing: 15,
                      spacing: 15,
                      children: listDeXuat.map((item) {
                        int index = listDeXuat.indexOf(item);
                        return Stack(
                          children: [
                            Container(
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
                              width:
                                  MediaQuery.of(context).size.width * .7 / 2 -
                                      8,
                              height: 160,
                              child: TextButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 6)),
                                    backgroundColor: MaterialStateProperty.all(
                                        checkColor(index)),
                                    shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))))),
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                      backgroundColor: Colors.white,
                                      // shape: const RoundedRectangleBorder(
                                      //   borderRadius: BorderRadius.vertical(
                                      //     top: Radius.circular(15.0),
                                      //   ),
                                      // ),
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
                                              0.95,
                                          child: ProductDetail(
                                            details: item,
                                            index: index,
                                            checkColor: (index) =>
                                                checkColor(index),
                                            checkTextColor: (index) =>
                                                checkColorText(index),
                                          ),
                                        );
                                      });
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      item["img"],
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                        child: Text(
                                      item["title"],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          item["price"],
                                          style: TextStyle(
                                              color: checkColorText(index),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "đ",
                                          style: TextStyle(
                                            color: checkColorText(index),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        )
                                      ],
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
                                  child: Icon(
                                    Icons.favorite_border_outlined,
                                    size: 20,
                                    color: checkColorText(index),
                                  ),
                                ))
                          ],
                        );
                      }).toList(),
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
