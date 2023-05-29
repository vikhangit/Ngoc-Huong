import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/home/banner.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_tin_tuc.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<String> bannerList = [
  "assets/images/Home/banner1.jpg",
  "assets/images/Home/banner2.jpg",
  "assets/images/Home/banner3.jpg"
];

List toolServices = [
  {"icon": "assets/images/Home/Services/phun-xam.png", "title": "Phun xăm"},
  {
    "icon": "assets/images/Home/Services/lam-dep-da.png",
    "title": "Chăm sóc da"
  },
  {"icon": "assets/images/Home/Services/spa.png", "title": "Spa"},
  {"icon": "assets/images/Home/Services/my-pham.png", "title": "Mỹ phẩm"},
  {"icon": "assets/images/Home/Services/thanh-vien.png", "title": "Thành viên"},
  {"icon": "assets/images/Home/Services/uu-dai.png", "title": "Ưu đãi"},
  {"icon": "assets/images/Home/Services/kien-thuc.png", "title": "Kiến thức"},
  {"icon": "assets/images/Home/Services/tu-van.png", "title": "Tư vấn"},
];

List newsList = [];
bool showAppBar = false;
int current = 0;
CarouselController buttonCarouselController = CarouselController();
Widget view = Container();
late PageController _pageController;

class _HomeScreenState extends State<HomeScreen> {
  LocalStorage storage = LocalStorage("auth");
  GlobalKey<CarouselSliderState> _sliderKey = GlobalKey();
  @override
  void initState() {
    // storage.setItem("authen", "false");
    callNewsApi().then((value) => setState(() => newsList = value));
    super.initState();

    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    // storage.setItem("authen", "false");
    super.dispose();
  }

  // final LocalStorage storage = LocalStorage("auth.json");
  void pageChange(int index, CarouselPageChangedReason reason) {
    setState(() {
      current = index;
    });
  }

  void clickDotPageChange(int index) {
    setState(() {
      current = index;
      buttonCarouselController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  void checkView(int index) {
    switch (index) {
      case 0:
        break;
      default:
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
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
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
            headerWidget: banner(
                context,
                (index, reason) => pageChange(index, reason),
                bannerList,
                (index) => clickDotPageChange(index),
                storage.getItem("lastname").toString(),
                storage,
                buttonCarouselController,
                current,
                _sliderKey),
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
              children: const <Widget>[
                Text(
                  "Ưu đãi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF555555),
                  ),
                ),
                InkWell(
                  child: Text(
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
            SizedBox(
              height: 150,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        fit: BoxFit.cover,
                        "assets/images/Home/Disscount/img1.jpg",
                      ),
                    ),
                  );
                },
              ),
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
              children: const <Widget>[
                Text(
                  "Tin tức",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF555555),
                  ),
                ),
                InkWell(
                  child: Text(
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
            if (newsList.isNotEmpty)
              Column(
                children: newsList.map((item) {
                  return item["cate_name"].toString().toLowerCase() == "tin tức"
                      ? GestureDetector(
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                Container(
                                  height: 10,
                                ),
                                Text(
                                  DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item["date_updated"])),
                                  style: const TextStyle(
                                      color: Color(0xFF555555),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          ))
                      : Container();
                }).toList(),
              )
          ],
        ),
      )
    ],
  );
}
