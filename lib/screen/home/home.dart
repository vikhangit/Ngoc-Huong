import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List toolServices = [
  {"icon": "assets/images/Home/Services/phun-xam.png", "title": "Phun xăm"},
  {"icon": "assets/images/Home/Services/lam-dep-da.png", "title": "Làm đẹp da"},
  {"icon": "assets/images/Home/Services/spa.png", "title": "Spa"},
  {"icon": "assets/images/Home/Services/my-pham.png", "title": "Mỹ phẩm"},
  {"icon": "assets/images/Home/Services/thanh-vien.png", "title": "Thành viên"},
  {"icon": "assets/images/Home/Services/uu-dai.png", "title": "Ưu đãi"},
  {"icon": "assets/images/Home/Services/kien-thuc.png", "title": "Kiến thức"},
  {"icon": "assets/images/Home/Services/tu-van.png", "title": "Tư vấn"},
];
bool showAppBar = false;
int current = 0;

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final CarouselController controller = CarouselController();
  LocalStorage storageAuth = LocalStorage("auth");
  LocalStorage storageToken = LocalStorage('token');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  void goToService(BuildContext context, int index) {
    switch (index) {
      case 0:
        {
          Navigator.pushNamed(context, "phunXam");
          break;
        }
      case 1:
        {
          Navigator.pushNamed(context, "lamdepda");
          break;
        }
      case 2:
        {
          Navigator.pushNamed(context, "spa");
          break;
        }
      case 3:
        {
          Navigator.pushNamed(context, "mypham");
          break;
        }
      case 4:
        {
          Navigator.pushNamed(context, "hangthanhvien");
          break;
        }
      case 5:
        {
          Navigator.pushNamed(context, "uudai");
          break;
        }
      case 6:
        {
          Navigator.pushNamed(context, "kienthuc");
          break;
        }
      case 7:
        {
          Navigator.pushNamed(context, "tuvan");
          break;
        }
      default:
    }
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    print(storageAuth.getItem("phone"));
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: const MyBottomMenu(
          active: 0,
        ),
        drawer: const MyLeftMenu(),
        body: RefreshIndicator(
          onRefresh: () => refreshData(),
          child: DraggableHome(
            leading: Container(),
            title: const Text(
              "Trang chủ",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            headerExpandedHeight: 0.25,
            headerWidget: FutureBuilder(
              future: callBannerHoemApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.toList();
                  return Stack(
                    fit: StackFit.passthrough,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: CarouselSlider(
                            carouselController: controller,
                            options: CarouselOptions(
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1000),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.25),
                            items: list.map((item) {
                              return FractionallySizedBox(
                                widthFactor: 1,
                                heightFactor: 1,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(
                                    "$apiUrl${item["hinh_anh"]}?$token",
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                      Positioned(
                          bottom: 10,
                          left: 0,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                storageAuth.getItem("existAccount") == null &&
                                        storageAuth.getItem("phone") == null
                                    ? InkWell(
                                        onTap: () {
                                          storage.deleteItem("typeOTP");
                                          showModalBottomSheet<void>(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(15.0),
                                                ),
                                              ),
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.96,
                                                    child: const ModalPhone());
                                              });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                width: 35,
                                                height: 35,
                                                "assets/images/account.png",
                                              ),
                                              const Text(
                                                "Đăng nhập",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : storageAuth.getItem("existAccount") !=
                                                null &&
                                            storageAuth.getItem("phone") == null
                                        ? InkWell(
                                            onTap: () {
                                              storage.deleteItem("typeOTP");
                                              showModalBottomSheet<void>(
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  isScrollControlled: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.96,
                                                      child:
                                                          const ModalPassExist(),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    width: 35,
                                                    height: 35,
                                                    "assets/images/account.png",
                                                  ),
                                                  const Text(
                                                    "Đăng nhập",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : FutureBuilder(
                                            future: getProfile(
                                                storageAuth.getItem("phone")),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  "Chào ${snapshot.data![0]["ten_kh"]}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400),
                                                );
                                              } else {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          ),
                                Row(
                                    children:
                                        List.generate(list.length, (index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 0 : 8),
                                    height: 5,
                                    width: 30,
                                    child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 5))),
                                      onPressed: () {
                                        controller.animateToPage(index,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            curve: Curves.easeIn);
                                      },
                                      child: Container(),
                                    ),
                                  );
                                }))
                              ],
                            ),
                          )),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            expandedBody: null,
            curvedBodyRadius: 0,
            body: [
              listView(
                  context, (context, index) => goToService(context, index)),
            ],
            fullyStretchable: true,
            backgroundColor: Colors.white,
            appBarColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

ListView listView(BuildContext context,
    Function(BuildContext context, int index) goToService) {
  return ListView(
    padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    children: [
      const SizedBox(
        height: 15,
      ),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: toolServices.map((item) {
          int index = toolServices.indexOf(item);
          return SizedBox(
            width: MediaQuery.of(context).size.width / 4 - 15,
            // height: 90,
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 0))),
              onPressed: () {
                goToService(context, index);
              },
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    width: 30,
                    height: 30,
                    "${item["icon"]}",
                    fit: BoxFit.contain,
                  ),
                  Text(
                    "${item["title"]}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
      Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Ưu đãi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF555555),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "uudai");
                  },
                  child: const Text(
                    "Xem thêm",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFA9A9A9),
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: 30,
            ),
            FutureBuilder(
              future: callNewsApi("647015e1706fa019e66e936b"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 180,
                    child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.sublist(0, 4).map((item) {
                          int index = snapshot.data!.indexOf(item);
                          return Container(
                            margin: EdgeInsets.only(left: index != 0 ? 15 : 0),
                            width: MediaQuery.of(context).size.width - 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                "$apiUrl${item["picture"]}?$token",
                                fit: BoxFit.cover,
                                height: 180,
                              ),
                            ),
                          );
                        }).toList()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Tin tức",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF555555),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "tin_tuc");
                  },
                  child: const Text(
                    "Xem thêm",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFA9A9A9),
                    ),
                  ),
                )
              ],
            ),
            FutureBuilder(
              future: callNewsApi("647015b9706fa019e66e9333"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.sublist(0, 2).map((item) {
                      return GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                                backgroundColor: Colors.white,
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
                                      child: ChiTietTinTuc(
                                        detail: item,
                                      ));
                                });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 220,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      "$apiUrl${item["picture"]}?$token",
                                      height: 135,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Text(item["title"],
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                Container(
                                  height: 10,
                                ),
                                Text(
                                  DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item["date_updated"])),
                                  style: const TextStyle(
                                      color: Color(0xFF555555),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ));
                    }).toList(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      )
    ],
  );
}
