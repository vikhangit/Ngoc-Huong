import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class SpaScreen extends StatefulWidget {
  const SpaScreen({super.key});

  @override
  State<SpaScreen> createState() => _SpaScreenState();
}

List loaidichvu = [
  {
    "img": "assets/images/Services/Spa/TamTrang/img1.jpg",
    "title": "Phủ trắng nano",
    "sub_title":
        "Công nghệ phủ trắng Nano với các hạt dưỡng chất siêu nhỏ, tia nano tác động..."
  },
  {
    "img": "assets/images/Services/Spa/TamTrang/img1.jpg",
    "title": "Máy phi thuyền",
    "sub_title":
        "Công nghệ phủ trắng Nano với các hạt dưỡng chất siêu nhỏ, tia nano tác động..."
  },
  {
    "img": "assets/images/Services/Spa/TamTrang/img1.jpg",
    "title": "Phủ trắng nano",
    "sub_title":
        "Công nghệ phủ trắng Nano với các hạt dưỡng chất siêu nhỏ, tia nano tác động..."
  },
];

List trietlong = [
  {
    "img": "assets/images/Services/Spa/TrietLong/img1.jpg",
    "title": "Gói triệt lông 2 tuần",
    "sub_title":
        "Triệt lông là phương pháp cắt đứt nguồn dinh dưỡng, ngăn chặn nguồn dinh dưỡng đến từng sợi..."
  },
  {
    "img": "assets/images/Services/Spa/TrietLong/img1.jpg",
    "title": "Gói triệt lông 2 tuần",
    "sub_title":
        "Triệt lông là phương pháp cắt đứt nguồn dinh dưỡng, ngăn chặn nguồn dinh dưỡng đến từng sợi..."
  },
];

class _SpaScreenState extends State<SpaScreen> {
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
              title: const Text("Spa",
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
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 20),
                      child: const Text(
                        "Tắm trắng",
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
                          height: 150,
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
                                    width: 164,
                                    fit: BoxFit.cover,
                                    // height: 140,
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
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: Text(
                                              item["sub_title"],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
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
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 40, bottom: 20),
                      child: const Text(
                        "Triệt lông",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Column(
                      children: trietlong.map((item) {
                        int index = trietlong.indexOf(item);
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
                          height: 250,
                          child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(10)),
                                        child: Image.asset(
                                          item["img"],
                                          height: 163,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item["title"],
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5, bottom: 10),
                                                child: Text(
                                                  item["sub_title"],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                  Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                          const EdgeInsets.all(
                                                              2),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          6)),
                                                          color:
                                                              Colors.red[200]),
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
                                      ))
                                ],
                              )),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )));
  }
}
