import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class LamDepDaScreen extends StatefulWidget {
  const LamDepDaScreen({super.key});

  @override
  State<LamDepDaScreen> createState() => _LamDepDaScreenState();
}

List dichvucay = [
  {
    "img": "assets/images/Services/ChamSocDa/DichVuCay/img1.jpg",
    "title": "Trắng da mặt"
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuCay/img2.jpg",
    "title": "Collagen tươi"
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuCay/img1.jpg",
    "title": "Trắng da mặt"
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuCay/img2.jpg",
    "title": "Collagen tươi"
  },
];
List dichvuxoa = [
  {
    "img": "assets/images/Services/ChamSocDa/DichVuXoa/img1.jpg",
    "title": "Xóa thâm vùng mắt"
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuXoa/img2.jpg",
    "title": "Xóa mụn"
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuXoa/img1.jpg",
    "title": "Xóa thâm vùng mắt"
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuXoa/img2.jpg",
    "title": "Xóa mụn"
  },
];

List loaidichvu = [
  {
    "img": "assets/images/Services/ChamSocDa/DichVuKhac/img1.jpg",
    "title": "Giải độc",
    "sub_title":
        "Bao gồm nhiều bước giúp thải độc tố tích tụ lâu ngày trong da, đồng thời làm sạch.."
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuKhac/img2.jpg",
    "title": "Thu nhỏ lỗ chân lông",
    "sub_title": "Đối với những cặp lông mày đậm, để đảm bảo màu sau này..."
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuKhac/img1.jpg",
    "title": "Giải độc",
    "sub_title":
        "Bao gồm nhiều bước giúp thải độc tố tích tụ lâu ngày trong da, đồng thời làm sạch.."
  },
  {
    "img": "assets/images/Services/ChamSocDa/DichVuKhac/img2.jpg",
    "title": "Thu nhỏ lỗ chân lông",
    "sub_title":
        "Laser Toning là bước đột phá trong việc thu nhỏ lỗ chân lông bằng công nghệ laser."
  },
];

class _LamDepDaScreenState extends State<LamDepDaScreen> {
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
              title: const Text("Chăm sóc da",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            drawer: const MyLeftMenu(),
            body: SingleChildScrollView(
              // reverse: true,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: const Text(
                        "Dịch vụ cấy",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 180,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: dichvucay.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(left: index != 0 ? 15 : 0),
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.asset(
                                        dichvucay[index]["img"],
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                        child: Text(
                                      "${dichvucay[index]["title"]}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ))
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: const Text(
                        "Dịch vụ xóa",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 180,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: dichvuxoa.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(left: index != 0 ? 15 : 0),
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.asset(
                                        dichvuxoa[index]["img"],
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                        child: Text(
                                      "${dichvuxoa[index]["title"]}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ))
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 20),
                      child: const Text(
                        "Dịch vụ khác",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Column(
                      children: loaidichvu.map((item) {
                        int index = loaidichvu.indexOf(item);
                        return Container(
                          margin: EdgeInsets.only(
                              left: 15, right: 15, top: index != 0 ? 15 : 0),
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
                          height: 140,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image.asset(
                                    item["img"],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      children: [
                                        Text(
                                          item["title"],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: Text(
                                              item["sub_title"],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            print("124");
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(4,
                                                      4), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  6)),
                                                      color: Colors.red[200]),
                                                  child: Image.asset(
                                                    "assets/images/calendar-black.png",
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                const Text(
                                                  "Đặt lịch",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            print("124");
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(4,
                                                      4), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    6)),
                                                        color: Colors.red[200]),
                                                    child: Image.asset(
                                                      "assets/images/call-black.png",
                                                      width: 20,
                                                      height: 20,
                                                    )),
                                                const Text(
                                                  "Tư vấn",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )));
  }
}
