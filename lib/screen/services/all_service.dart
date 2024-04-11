import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class AllServiceScreen extends StatefulWidget {
  final List listTab;
  final bool? isShop;
  const AllServiceScreen({super.key, required this.listTab, this.isShop});

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
  final ProductModel productModel = ProductModel();
  final LocalStorage storageToken = LocalStorage("customer_token");
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    setState(() {
      showIndex = "";
      listAction.clear();
    });
    setState(() {
      widget.listTab.map((e) {
        if (e["GroupCode"] != "GDC") {
          switch (e["GroupCode"]) {
            case "Phun thêu thẩm mỹ":
              {
                listAction.insert(0, {
                  "img": "assets/images/may.png",
                  "title": e["GroupName"],
                  "code": e["GroupCode"]
                });
              }
            case "Điều trị da":
              {
                listAction.add({
                  "img": "assets/images/dieu-tri.png",
                  "title": e["GroupName"],
                  "code": e["GroupCode"]
                });
              }
            //  case "Tắm trắng Face & Body":
            //     {
            //       listAction.add({
            //         "img": "assets/images/tam-trang.png",
            //         "title": e["GroupCode"],
            //         "code": e["GroupCode"]
            //       });
            //     }
            case "Trẻ hóa & chăm sóc da":
              {
                listAction.add({
                  "img": "assets/images/tre-hoa.png",
                  "title": e["GroupName"],
                  "code": e["GroupName"]
                });
              }
            case "Triệt Lông":
              {
                listAction.add({
                  "img": "assets/images/waxing.png",
                  "title": e["GroupCode"],
                  "code": e["GroupName"]
                });
              }
            // case "Giảm Béo":
            //   {
            //     listAction.add({
            //       "img": "assets/images/giam-beo.png",
            //       "title": e["GroupCode"],
            //       "code": e["GroupCode"]
            //     });
            //   }
            default:
              {
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
    scrollController.dispose();
  }

  void goToAction(String code) {
    setState(() {
      activeCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: 100,
                child: const MyBottomMenu(
                  active: 1,
                )),
            appBar: AppBar(
              leadingWidth: 45,
              centerTitle: true,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
            body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 8,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          height: MediaQuery.of(context).size.height - 250,
                          width: MediaQuery.of(context).size.width * .25,
                          child: ListView(
                            children: listAction.map((item) {
                              int index = listAction.indexOf(item);
                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 3, top: 3),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: activeCode == item["code"]
                                            ? const BorderSide(
                                                width: 3, color: Colors.red)
                                            : BorderSide.none)),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 4 - 60,
                                child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 18, horizontal: 10)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              activeCode == item["code"]
                                                  ? Colors.white
                                                  : Colors.red[100]),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0))))),
                                  onPressed: () {
                                    goToAction(item["code"]);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                          width: MediaQuery.of(context).size.width * .75 - 14,
                          height: MediaQuery.of(context).size.height - 220,
                          child: ListView(
                            // crossAxisAlignment: CrossAxisAlignment.start,s
                            // controller: scrollController,
                            children: [
                              FutureBuilder(
                                future:
                                    servicesModel.getServiceByGroup(activeCode),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List list = snapshot.data!.toList();
                                    return Wrap(
                                        // runSpacing: 8,
                                        alignment: WrapAlignment.spaceBetween,
                                        children: list.map((item) {
                                          return GestureDetector(
                                              onTap: () => setState(() {
                                                    showIndex = item["Code"];
                                                  }),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  .7 /
                                                                  2 -
                                                              5,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 2,
                                                              right: 2,
                                                              top: 8),
                                                      height: 230,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    15)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChiTietScreen(
                                                                            detail:
                                                                                item,
                                                                            isShop:
                                                                                widget.isShop,
                                                                          )));
                                                            },
                                                            child: Column(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  child: Image
                                                                      .network(
                                                                    "${item["Image_Name"] ?? "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: 120,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "${item["Name"]}",
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          mainColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                const SizedBox(
                                                                  height: 2,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          8)),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 2,
                                                                  offset: const Offset(
                                                                      0,
                                                                      1), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      if (widget
                                                                              .isShop !=
                                                                          null) {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => ChiTietScreen(
                                                                                      detail: item,
                                                                                      isShop: widget.isShop,
                                                                                    )));
                                                                      } else {
                                                                        if (storageToken.getItem("customer_token") ==
                                                                            null) {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => const LoginScreen()));
                                                                        } else {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => BookingServices(
                                                                                        dichvudachon: item,
                                                                                      )));
                                                                        }
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              8),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius: const BorderRadius
                                                                            .all(
                                                                            Radius.circular(8)),
                                                                        color:
                                                                            mainColor,
                                                                      ),
                                                                      child: widget.isShop !=
                                                                              null
                                                                          ? item["ExchangeCoin"] != null
                                                                              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                  Image.asset(
                                                                                    "assets/images/icon/Xu1.png",
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 3,
                                                                                  ),
                                                                                  Text(
                                                                                    "${item["ExchangeCoin"]}",
                                                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.amber),
                                                                                  ),
                                                                                ])
                                                                              : const Text(
                                                                                  "Đang cập nhật...",
                                                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.amber),
                                                                                )
                                                                          : const Text("Đặt lịch", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.amber)),
                                                                    )),
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              ));
                                        }).toList());
                                  } else {
                                    return Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height -
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
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
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
                                height: 20,
                              )
                            ],
                          ),
                        )
                      ],
                    )))));
  }
}
