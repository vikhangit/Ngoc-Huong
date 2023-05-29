import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';

class PhunXamScreen extends StatefulWidget {
  const PhunXamScreen({super.key});

  @override
  State<PhunXamScreen> createState() => _PhunXamScreenState();
}

List phumxammay = [
  {
    "img": "assets/images/Services/PhunXamMay/img1.jpg",
    "title": "Phun tán bột lông mày"
  },
  {
    "img": "assets/images/Services/PhunXamMay/img2.jpg",
    "title": "Lông mày khắc sợi"
  },
  {
    "img": "assets/images/Services/PhunXamMay/img1.jpg",
    "title": "Phun tán bột lông mày"
  },
  {
    "img": "assets/images/Services/PhunXamMay/img2.jpg",
    "title": "Lông mày khắc sợi"
  },
];

List phummimat = [
  {
    "img": "assets/images/Services/PhunXamMi/img1.jpg",
    "title": "Mí mắt tự nhiên"
  },
  {
    "img": "assets/images/Services/PhunXamMi/img2.png",
    "title": "Mí mắt trang điểm"
  },
  {
    "img": "assets/images/Services/PhunXamMi/img3.png",
    "title": "Mí mắt nước Eyeliner"
  },
  {
    "img": "assets/images/Services/PhunXamMi/img1.jpg",
    "title": "Mí mắt tự nhiên"
  },
];

List phumxammoi = [
  {
    "img": "assets/images/Services/PhunXamMoi/img1.jpg",
    "title": "Cấy son tươi Hàn Quốc"
  },
  {
    "img": "assets/images/Services/PhunXamMoi/img2.jpg",
    "title": "Cấy son tươi Pháp"
  },
  {
    "img": "assets/images/Services/PhunXamMoi/img1.jpg",
    "title": "Cấy son tươi Hàn Quốc"
  },
  {
    "img": "assets/images/Services/PhunXamMoi/img2.jpg",
    "title": "Cấy son tươi Pháp"
  },
];

List loaidichvu = [
  {
    "img": "assets/images/Services/PhunXamMay/img1.jpg",
    "title": "Dịch vụ phun/ xăm mới",
    "sub_title": "Đối với những cặp lông mày đậm, để đảm bảo màu sau này..."
  },
  {
    "img": "assets/images/Services/PhunXamMoi/img1.jpg",
    "title": "Dịch vụ xóa",
    "sub_title": "Đối với những cặp lông mày đậm, để đảm bảo màu sau này..."
  },
  {
    "img": "assets/images/Services/PhunXamMoi/img2.jpg",
    "title": "Thu nhỏ lỗ chân lôngi",
    "sub_title": "Đối với những cặp lông mày đậm, để đảm bảo màu sau này..."
  },
  {
    "img": "assets/images/Services/PhunXamMoi/img1.jpg",
    "title": "Dịch vụ phun/ xăm mới",
    "sub_title": "Đối với những cặp lông mày đậm, để đảm bảo màu sau này..."
  },
];

class _PhunXamScreenState extends State<PhunXamScreen> {
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
              title: const Text("Phun Xăm",
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
                        "Phun xăm mày",
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
                        itemCount: phumxammay.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.95,
                                        child: ChiTietScreen());
                                  });
                            },
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
                                        phumxammay[index]["img"],
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${phumxammay[index]["title"]}",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: const Text(
                        "Phun mí mắt",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: phummimat.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.95,
                                        child: ChiTietScreen());
                                  });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(left: index != 0 ? 10 : 0),
                                width:
                                    MediaQuery.of(context).size.width / 3 - 25,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.asset(
                                        phummimat[index]["img"],
                                        height: 106,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                        child: Text(
                                      "${phummimat[index]["title"]}",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12,
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
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: const Text(
                        "Phun xăm môi",
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
                        itemCount: phumxammoi.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChiTietScreen()));
                            },
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
                                        phumxammoi[index]["img"],
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                        child: Text(
                                      "${phumxammoi[index]["title"]}",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
                        "Loại dịch vụ",
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
                          height: 130,
                          child: TextButton(
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.95,
                                        child: ChiTietScreen());
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
                                            margin:
                                                const EdgeInsets.only(top: 5),
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
                      height: 15,
                    ),
                  ],
                ),
              ),
            )));
  }
}
