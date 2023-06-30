import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

List listNotify = [
  // {
  //   "tieu_de": "Gói thu nhỏ lỗ chân lông - Bảo hành",
  //   "tieu_de_phu": "Ngày trị liệu: 20/10/2023",
  //   "date": "11/5/2023",
  //   "trang_thai": "new"
  // },
  // {
  //   "tieu_de": "Title 1",
  //   "tieu_de_phu": "Ngày trị liệu: 20/10/2023",
  //   "date": "11/5/2023",
  //   "trang_thai": "new"
  // },
  // {
  //   "tieu_de": "Title 2",
  //   "tieu_de_phu": "Ngày trị liệu: 20/10/2023",
  //   "date": "11/5/2023",
  //   "trang_thai": ""
  // },
  // {
  //   "tieu_de": "Title 3",
  //   "tieu_de_phu": "Ngày trị liệu: 20/10/2023",
  //   "date": "11/5/2023",
  //   "trang_thai": "new"
  // }
];

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(
              active: 2,
            ),
            drawer: const MyLeftMenu(),
            appBar: AppBar(
              centerTitle: true,
              bottomOpacity: 0.0,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 5))),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.done_all,
                      size: 24,
                      color: Colors.black,
                    )),
              ],
              title: const Text("Thông báo",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    if (listNotify.isNotEmpty)
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 40),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(left: index != 0 ? 15 : 0),
                                decoration: BoxDecoration(
                                    color: Colors.amber[100],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                width: 100,
                                child: const Text(
                                  "#tatca",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                    listNotify.isNotEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height - 320,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: listNotify.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
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
                                  child: TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 5))),
                                    onPressed: () {},
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(listNotify[index]
                                                    ["trang_thai"] ==
                                                "new"
                                            ? "assets/images/Notifications/bell2.png"
                                            : "assets/images/Notifications/bell1.png"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  110,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${listNotify[index]["tieu_de"]}",
                                                    style: TextStyle(
                                                        color: listNotify[index]
                                                                    [
                                                                    "trang_thai"] ==
                                                                "new"
                                                            ? Colors.black
                                                            : Colors.black38,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "${listNotify[index]["tieu_de_phu"]}",
                                                    style: TextStyle(
                                                        color: listNotify[index]
                                                                    [
                                                                    "trang_thai"] ==
                                                                "new"
                                                            ? Colors.black
                                                            : Colors.black38,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "1 giờ trước",
                                                    style: TextStyle(
                                                        color: listNotify[index]
                                                                    [
                                                                    "trang_thai"] ==
                                                                "new"
                                                            ? Colors.black
                                                            : Colors.black38,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (listNotify[index]
                                                    ["trang_thai"] ==
                                                "new")
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    color: Color(0xFFDC202E)),
                                              )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Image.asset(
                                    "assets/images/Notifications/noti1.png"),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: const Text(
                                  "Bạn chưa có thông báo nào trong 30 ngày gần đây",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: const Text(
                                  "Vui lòng thử lại sau!",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          )
                  ],
                ),
              ),
            )));
  }
}
