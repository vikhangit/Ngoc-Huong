import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';

class AllServiceScreen extends StatefulWidget {
  final List listTab;
  const AllServiceScreen({super.key, required this.listTab});

  @override
  State<AllServiceScreen> createState() => _AllServiceScreenState();
}

List listAction = [];

String showIndex = "";
String activeCode = listAction[0]["code"];
bool isLoading = false;

class _AllServiceScreenState extends State<AllServiceScreen>
    with TickerProviderStateMixin {
  final ServicesModel servicesModel = ServicesModel();
  final LocalStorage storageToken = LocalStorage("customer_token");

  @override
  void initState() {
    super.initState();
    setState(() {
      showIndex = "";
      listAction.clear();
    });
    setState(() {
      widget.listTab.map((e) {
        if (e["GroupCode"] != "GDC") {
          switch(e["GroupCode"]){
            case "Điều trị da":{
              listAction.add({
                "img": "assets/images/dieu-tri.png",
                "title": e["GroupCode"],
                "code": e["GroupCode"]
              });
            }
            case "Phun thêu thẩm mỹ":{
              listAction.add({
                "img": "assets/images/may.png",
                "title": e["GroupCode"],
                "code": e["GroupCode"]
              });
            }
            case "Tắm trắng Face & Body":{
              listAction.add({
                "img": "assets/images/tam-trang.png",
                "title": e["GroupCode"],
                "code": e["GroupCode"]
              });
            }
            case "Trẻ hóa & chăm sóc da":{
              listAction.add({
                "img": "assets/images/tre-hoa.png",
                "title": e["GroupCode"],
                "code": e["GroupCode"]
              });
            }
            case "Triệt Lông":{
              listAction.add({
                "img": "assets/images/waxing.png",
                "title": e["GroupCode"],
                "code": e["GroupCode"]
              });
            }
            case "Giảm Béo":{
              listAction.add({
                "img": "assets/images/giam-beo.png",
                "title": e["GroupCode"],
                "code": e["GroupCode"]
              });
            }
            default: {
              break;
            }
          }
        }
      }).toList();
      activeCode = listAction[0]["code"];
    });
  }

  @override
  void dispose() {
    super.dispose();
    showIndex = "";
  }

  void goToAction(String code) {
    setState(() {
      activeCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(active: 0),
            appBar: AppBar(
              primary: false,
              elevation: 0.0,
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
              title: const Text("Dịch vụ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16,
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
                                    left: activeCode == item["code"]
                                        ? const BorderSide(
                                            width: 3, color: Colors.red)
                                        : BorderSide.none)),
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 18, horizontal: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      activeCode == item["code"]
                                          ? Colors.red[100]
                                          : Colors.blue[100]),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))))),
                              onPressed: () {
                                goToAction(item["code"]);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    item["img"],
                                    width: 50,
                                    height: 50,
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ))
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75 - 20,
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: servicesModel.getServiceByGroup(activeCode),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List list = snapshot.data!.toList();
                                return Wrap(
                                    runSpacing: 8,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: list.map((item) {
                                      return GestureDetector(
                                          onTap: () => setState(() {
                                                showIndex = item["Code"];
                                              }),
                                          child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .7 /
                                                          2 -
                                                      4,
                                                  height: 245,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 6),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  6)),
                                                      border: Border.all(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          width: 1)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image.network(
                                                            "${item["Image_Name"]}",
                                                            // "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",
                                                            fit: BoxFit.cover,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 120,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${item["Name"]}",
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                showIndex =
                                                                    item[
                                                                        "Code"];
                                                              });
                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary)),
                                                            child: const Text(
                                                                "Xem thêm",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white))),
                                                      )
                                                    ],
                                                  )),
                                              if (showIndex.isNotEmpty &&
                                                  showIndex == item["Code"])
                                                Positioned.fill(
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6)),
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4)),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    showIndex =
                                                                        "";
                                                                  });
                                                                  showModalBottomSheet<
                                                                          void>(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      clipBehavior:
                                                                          Clip
                                                                              .antiAliasWithSaveLayer,
                                                                      context:
                                                                          context,
                                                                      isScrollControlled:
                                                                          true,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Container(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            height: MediaQuery.of(context).size.height * 0.95,
                                                                            child: ChiTietScreen(
                                                                              detail: item,
                                                                            ));
                                                                      });
                                                                },
                                                                child:
                                                                    Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                6,
                                                                            horizontal:
                                                                                10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.blue[500],
                                                                          borderRadius: const BorderRadius
                                                                              .all(
                                                                              Radius.circular(4)),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Image.asset("assets/images/eye-white.png",
                                                                                width: 18,
                                                                                height: 18),
                                                                            const SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            const Text(
                                                                              "Xem chi tiết",
                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w400),
                                                                            )
                                                                          ],
                                                                        ))),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    showIndex = "";
                                                                  });
                                                                  if (storageToken
                                                                      .getItem(
                                                                      "customer_token") ==
                                                                      null) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder:
                                                                                (context) =>
                                                                            const LoginScreen()));
                                                                  } else {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                BookingServices(
                                                                                  dichvudachon:
                                                                                  item,
                                                                                )));
                                                                  }
                                                                },
                                                                child: Container(
                                                                    margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 10),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical: 6,
                                                                        horizontal:
                                                                        10),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(
                                                                                4)),
                                                                        color: Colors
                                                                            .blue[
                                                                        900]),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image.asset(
                                                                            "assets/images/calendar-solid-white.png",
                                                                            width: 18,
                                                                            height: 18),
                                                                        const SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        const Text(
                                                                          "Đặt lịch",
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              10,
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight:
                                                                              FontWeight.w400),
                                                                        )
                                                                      ],
                                                                    )))

                                                          ],
                                                        )))
                                            ],
                                          ));
                                    }).toList());
                              } else {
                                return Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height -
                                        250,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: LoadingIndicator(
                                            colors: kDefaultRainbowColors,
                                            indicatorType:
                                                Indicator.lineSpinFadeLoader,
                                            strokeWidth: 1,
                                            // pathBackgroundColor: Colors.black45,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Đang lấy dữ liệu")
                                      ],
                                    ));
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
                ))));
  }
}
