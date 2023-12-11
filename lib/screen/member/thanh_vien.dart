import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/memberModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class ThanhVienScreen extends StatefulWidget {
  const ThanhVienScreen({super.key});

  @override
  State<ThanhVienScreen> createState() => _MyPhamScreenState();
}

int? _selectedIndex;
int currentIndex = 0;

class _MyPhamScreenState extends State<ThanhVienScreen>
    with TickerProviderStateMixin {
  TabController? tabController;

  final ProfileModel profileModel = ProfileModel();
  final MemberModel memberModel = MemberModel();
  final ScrollController scrollController = ScrollController();
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    tabController = TabController(length: 4, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
  }

  void _getActiveTabIndex() {
    setState(() {
      currentIndex = tabController!.index;
      buttonCarouselController.jumpToPage(tabController!.index);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
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
    List rank = [
      {"card": silver(context), "rank": "Bạc", "point": 100},
      {"card": gold(context), "rank": "Vàng", "point": 250},
      {"card": platinum(context), "rank": "Bạch kim", "point": 500},
      {"card": diamond(context), "rank": "Kim cương", "point": 1000},
    ];
    return SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: 100,
                child: const MyBottomMenu(
                  active: -1,
                )),
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
            body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: FutureBuilder(
                future: profileModel.getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          // height: 190,
                          child: CarouselSlider.builder(
                              options: CarouselOptions(
                                height: 190,
                                aspectRatio: 1 / 2,
                                enlargeCenterPage: false,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                    tabController!.animateTo(index,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  });
                                },
                              ),
                              itemCount: rank.length,
                              carouselController: buttonCarouselController,
                              itemBuilder: (context, index, realIndex) {
                                return Container(
                                    margin: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        rank[index]["card"],
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30,
                                            height: 190,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!["CustomerName"]
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .monetization_on_outlined,
                                                        color:
                                                            Colors.yellow[300],
                                                        size: 28,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${snapshot.data!["Point"] ?? 0}",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                                                      Text(
                                                        rank[index]["rank"],
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 3,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: snapshot.data[
                                                                  "Point"] ==
                                                              null
                                                          ? 0
                                                          : (snapshot.data[
                                                                  "Point"] /
                                                              rank[index]
                                                                  ["point"]),
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${snapshot.data["Point"] ?? 0}",
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        rank[index]["point"]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  index == 3
                                                      ? const Text(
                                                          "Hãy thăng hạng kim cương để có thể hưởng thụ nhiều ưu đãi tuyệt vời nhất",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        )
                                                      : Text(
                                                          "Cần sử dụng thêm ${snapshot.data!["Point"] != null ? rank[index]["point"] - snapshot.data!["Point"] : rank[index]["point"]} điểm nữa để lên hạng ${rank[index + 1]["rank"]}",
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        )
                                                ],
                                              ),
                                            )),
                                        // Positioned(
                                        //     bottom: -150,
                                        //     left: 0,
                                        //     width: (MediaQuery.of(context)
                                        //             .size
                                        //             .width -
                                        //         30),
                                        //     height: 100,
                                        //     child: Container(
                                        //       margin:
                                        //           const EdgeInsets.symmetric(
                                        //               horizontal: 10),
                                        //       decoration: const BoxDecoration(
                                        //           color: Colors.grey,
                                        //           borderRadius:
                                        //               BorderRadius.vertical(
                                        //                   bottom:
                                        //                       Radius.circular(
                                        //                           12))),
                                        //     ))
                                      ],
                                    ));
                              }),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DotsIndicator(
                          onTap: (index) {
                            setState(() {
                              currentIndex = index;
                              buttonCarouselController.jumpToPage(index);
                              tabController!.animateTo(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear);
                            });
                          },
                          dotsCount: rank.length,
                          position: currentIndex,
                          decorator: DotsDecorator(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              size: Size(12, 8),
                              activeSize: Size(24, 8),
                              color: mainColor,
                              activeColor: mainColor,
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              spacing: EdgeInsets.all(1)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TabBar(
                            controller: tabController,
                            // padding: EdgeInsets.zero,
                            // indicatorPadding: EdgeInsets.zero,
                            tabAlignment: TabAlignment.start,
                            onTap: (tabIndex) {
                              setState(() {
                                currentIndex = tabIndex;
                                buttonCarouselController.jumpToPage(tabIndex);
                              });
                            },
                            labelColor: Theme.of(context).colorScheme.primary,
                            isScrollable: true,
                            unselectedLabelColor: Colors.black,
                            indicatorColor:
                                Theme.of(context).colorScheme.primary,
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "LexendDeca"),
                            tabs: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 20,
                                child: const Tab(text: "Bạc"),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 20,
                                child: const Tab(text: "Vàng"),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 20,
                                child: const Tab(text: "Bạch Kim"),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 4 - 20,
                                child: const Tab(
                                  text: "Kim Cương",
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child:
                              TabBarView(controller: tabController, children: [
                            FutureBuilder(
                              future: memberModel.getRank("TV"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView(children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          color: Colors.grey[300]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${snapshot.data!["Promotion"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Column(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.card_giftcard,
                                              size: 25,
                                              color: mainColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "${snapshot.data!["Benfits"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey))),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.card_giftcard,
                                              size: 25,
                                              color: mainColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "${snapshot.data!["Perks"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ))
                                          ],
                                        ),
                                      )
                                    ])
                                  ]);
                                } else {
                                  return const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  );
                                }
                              },
                            ),
                            FutureBuilder(
                              future: memberModel.getRank("Gold"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView(children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          color: Colors.grey[300]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${snapshot.data!["Promotion"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Column(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.card_giftcard,
                                              size: 25,
                                              color: mainColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "${snapshot.data!["Benfits"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey))),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.card_giftcard,
                                              size: 25,
                                              color: mainColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "${snapshot.data!["Perks"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ))
                                          ],
                                        ),
                                      )
                                    ])
                                  ]);
                                } else {
                                  return const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  );
                                }
                              },
                            ),
                            FutureBuilder(
                              future: memberModel.getRank("Platinum"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView(children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          color: Colors.grey[300]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${snapshot.data!["Promotion"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Column(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.card_giftcard,
                                              size: 25,
                                              color: mainColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "${snapshot.data!["Benfits"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey))),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.card_giftcard,
                                              size: 25,
                                              color: mainColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "${snapshot.data!["Perks"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ))
                                          ],
                                        ),
                                      )
                                    ])
                                  ]);
                                } else {
                                  return const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  );
                                }
                              },
                            ),
                            FutureBuilder(
                              future: memberModel.getRank("Diamond"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView(children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          color: Colors.grey[300]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${snapshot.data!["Promotion"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Column(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.card_giftcard,
                                              size: 25,
                                              color: mainColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "${snapshot.data!["Benfits"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey))),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.card_giftcard,
                                              size: 25,
                                              color: mainColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              "${snapshot.data!["Perks"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ))
                                          ],
                                        ),
                                      )
                                    ])
                                  ]);
                                } else {
                                  return const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  );
                                }
                              },
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  } else {
                    return const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: LoadingIndicator(
                              colors: kDefaultRainbowColors,
                              indicatorType: Indicator.lineSpinFadeLoader,
                              strokeWidth: 1,
                              // pathBackgroundColor: Colors.black45,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Đang lấy dữ liệu")
                        ],
                      ),
                    );
                  }
                },
              ),
            )));
  }
}

Widget diamond(BuildContext context) {
  return Container(
      height: 190,
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
              Color.fromRGBO(107, 218, 207, 1),
              Color.fromRGBO(208, 252, 255, 1),
              Color.fromRGBO(171, 234, 247, 1),
              Color.fromRGBO(126, 229, 232, 1)
            ]),
      ));
}

Widget silver(BuildContext context) {
  return Container(
      height: 190,
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
      height: 190,
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
      height: 190,
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
