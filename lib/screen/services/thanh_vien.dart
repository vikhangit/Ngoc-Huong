import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ThanhVienScreen extends StatefulWidget {
  const ThanhVienScreen({super.key});

  @override
  State<ThanhVienScreen> createState() => _MyPhamScreenState();
}

int? _selectedIndex;

class _MyPhamScreenState extends State<ThanhVienScreen>
    with TickerProviderStateMixin {
  LocalStorage storageAuth = LocalStorage("auth");
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
    debugPrint('CURRENT_PAGE $_selectedIndex');
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
            bottomNavigationBar:
                MyBottomMenu(active: 0, save: () => setState(() {})),
            appBar: AppBar(
              leadingWidth: 45,
              centerTitle: true,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
              title: const Text("Hạng thành viên",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            drawer: const MyLeftMenu(),
            body: ListView(
              children: [
                Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 30, top: 20),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        silver(context),
                        Positioned(
                            top: 0,
                            left: 0,
                            width: MediaQuery.of(context).size.width - 30,
                            height: 180,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  FutureBuilder(
                                    future: getProfile(
                                        storageAuth.getItem("phone")),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Map profile = snapshot.data![0];
                                        return Text(
                                          profile["ten_kh"]
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        color: Colors.yellow[300],
                                        size: 28,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Icon(
                                        Icons.circle,
                                        size: 5,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Text(
                                        "Đồng",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 3,
                                    child: const LinearProgressIndicator(
                                      value: 0,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "10.000.000",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Cần sử dụng thêm 10.000.000 VND nữa để lên hạng Bạc",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            )),
                        Positioned(
                            bottom: -10,
                            left: 0,
                            width: (MediaQuery.of(context).size.width - 30),
                            height: 10,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12))),
                            ))
                      ],
                    )),
                TabBar(
                    controller: tabController,
                    // padding: EdgeInsets.zero,
                    // indicatorPadding: EdgeInsets.zero,
                    onTap: (tabIndex) {
                      setState(() {
                        _selectedIndex = tabIndex;
                      });
                    },
                    labelColor: Theme.of(context).colorScheme.primary,
                    isScrollable: true,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: "LexendDeca"),
                    tabs: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: const Tab(
                          text: "Đồng",
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: const Tab(text: "Bạc"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: const Tab(text: "Vàng"),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: const Tab(text: "Bạch Kim"),
                      ),
                    ]),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: TabBarView(controller: tabController, children: [
                    ListView(children: [
                      Column(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: Colors.grey[300]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Tổng trị giá tiêu dùng",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "> 10 triệu VND",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                            children: List.generate(20, (index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: index != 0
                                        ? const BorderSide(
                                            width: 0.5, color: Colors.grey)
                                        : BorderSide.none)),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Home/Services/uu-dai.png",
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Ưu đãi $index",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          );
                        }))
                      ])
                    ]),
                    ListView(children: [
                      Column(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: Colors.grey[300]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Tổng trị giá tiêu dùng",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "> 20 triệu VND",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                            children: List.generate(20, (index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: index != 0
                                        ? const BorderSide(
                                            width: 0.5, color: Colors.grey)
                                        : BorderSide.none)),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Home/Services/uu-dai.png",
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Ưu đãi $index",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          );
                        }))
                      ])
                    ]),
                    ListView(children: [
                      Column(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: Colors.grey[300]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Tổng trị giá tiêu dùng",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "> 45 triệu VND",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                            children: List.generate(20, (index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: index != 0
                                        ? const BorderSide(
                                            width: 0.5, color: Colors.grey)
                                        : BorderSide.none)),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Home/Services/uu-dai.png",
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Ưu đãi $index",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          );
                        }))
                      ])
                    ]),
                    ListView(children: [
                      Column(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: Colors.grey[300]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Tổng trị giá tiêu dùng",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "> 70 triệu VND",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                            children: List.generate(20, (index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: index != 0
                                        ? const BorderSide(
                                            width: 0.5, color: Colors.grey)
                                        : BorderSide.none)),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Home/Services/uu-dai.png",
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Ưu đãi $index",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          );
                        }))
                      ])
                    ]),
                  ]),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            )));
  }
}

Widget bronze(BuildContext context) {
  return Container(
      height: 180,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 3),
              blurRadius: 8)
        ],
        gradient: LinearGradient(
            begin: Alignment(0.7658354043960571, 0.2429373413324356),
            end: Alignment(-0.24266093969345093, 0.25175198912620544),
            colors: [
              Color.fromRGBO(135, 87, 79, 1),
              Color.fromRGBO(195, 152, 118, 1),
              Color.fromRGBO(149, 95, 68, 1),
              Color.fromRGBO(146, 86, 68, 1)
            ]),
      ));
}

Widget silver(BuildContext context) {
  return Container(
      height: 180,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 3),
              blurRadius: 8)
        ],
        gradient: LinearGradient(
            begin: Alignment(0.7658354043960571, 0.2429373413324356),
            end: Alignment(-0.24266093969345093, 0.25175198912620544),
            colors: [
              Color.fromRGBO(171, 171, 171, 1),
              Color.fromRGBO(223, 223, 223, 1),
              Color.fromRGBO(196, 196, 196, 1),
              Color.fromRGBO(184, 184, 184, 1)
            ]),
      ));
}

Widget gold(BuildContext context) {
  return Container(
      height: 180,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 3),
              blurRadius: 8)
        ],
        gradient: LinearGradient(
            begin: Alignment(0.7658354043960571, 0.2429373413324356),
            end: Alignment(-0.24266093969345093, 0.25175198912620544),
            colors: [
              Color.fromRGBO(222, 193, 161, 1),
              Color.fromRGBO(251, 236, 215, 1),
              Color.fromRGBO(245, 223, 199, 1),
              Color.fromRGBO(213, 181, 156, 1)
            ]),
      ));
}

Widget platinum(BuildContext context) {
  return Container(
      height: 180,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 3),
              blurRadius: 8)
        ],
        gradient: LinearGradient(
            begin: Alignment(0.7658354043960571, 0.2429373413324356),
            end: Alignment(-0.24266093969345093, 0.25175198912620544),
            colors: [
              Color.fromRGBO(114, 137, 221, 1),
              Color.fromRGBO(208, 218, 255, 1),
              Color.fromRGBO(171, 187, 247, 1),
              Color.fromRGBO(126, 149, 232, 1)
            ]),
      ));
}
