import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/memberModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class ThanhVienScreen extends StatefulWidget {
  final int? ac;
  const ThanhVienScreen({super.key, this.ac});

  @override
  State<ThanhVienScreen> createState() => _MyPhamScreenState();
}

int? _selectedIndex;
int currentIndex = 0;
List rank = [];
Map profile = {};
bool isLoading = true;

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
    if (widget.ac != null) {
      setState(() {
        currentIndex = widget.ac!;
        tabController!.animateTo(currentIndex,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      });
    }
    tabController?.addListener(_getActiveTabIndex);
    profileModel.getProfile().then((value) => setState(() {
          profile = value;
        }));
    memberModel.getAllRank().then((value) => setState(() {
          rank = value.toList();
        }));
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _getActiveTabIndex() {
    setState(() {
      currentIndex = tabController!.index;
      buttonCarouselController.jumpToPage(tabController!.index);
      tabController!.animateTo(tabController!.index,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(rank);
    return SafeArea(
        
        bottom: false, top: false,
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
              child: isLoading
                  ? const Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                          ]),
                    )
                  : Column(
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
                                        Image.network(
                                          "${rank[currentIndex]["Image"]}",
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 190,
                                        ),
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30,
                                            child: Container(
                                              alignment: Alignment.topRight,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: index == 0
                                                      ? 42
                                                      : index == 1
                                                          ? 52
                                                          : index == 2
                                                              ? 41
                                                              : index == 3
                                                                  ? 22
                                                                  : 42,
                                                  vertical: 20),
                                              child: Text(
                                                profile["CustomerName"]
                                                    .toString()
                                                    .toUpperCase(),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),
                                            )),
                                        Positioned(
                                            bottom: -150,
                                            left: 0,
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30),
                                            height: 100,
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          bottom:
                                                              Radius.circular(
                                                                  12))),
                                            ))
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
                              size: const Size(12, 8),
                              activeSize: const Size(24, 8),
                              color: mainColor,
                              activeColor: mainColor,
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              spacing: const EdgeInsets.all(1)),
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
                              tabController!.animateTo(tabIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear);
                            });
                          },
                          labelColor: Theme.of(context).colorScheme.primary,
                          isScrollable: true,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: "Quicksand"),
                          tabs: rank
                              .map(
                                (e) => SizedBox(
                                  width: MediaQuery.of(context).size.width / 3 -
                                      20,
                                  child: Tab(text: "${e["CardName"]}"),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: TabBarView(
                              controller: tabController,
                              children: rank.map((e) {
                                int index = rank.indexOf(e);
                                return Column(children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        color: Colors.grey[300]),
                                    child: index == 3
                                        ? Text(
                                            profile["Point"] >=
                                                    rank[3]["PointUpLevel"]
                                                ? "Bạn đã đạt cấp độ tối đa và nhận những đặc quyền chỉ bạn mới có!"
                                                : "Bạn cần hơn ${rank[3]["PointUpLevel"] - profile["Point"]} điểm nữa để đạt cấp độ tối đa và nhận những đặc quyền chỉ bạn mới có!",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${profile["Point"] ?? 0} điểm",
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    "${rank[index + 1]["PointUpLevel"]}",
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 3,
                                                child: LinearProgressIndicator(
                                                    value: profile["Point"] == 0
                                                        ? 0
                                                        : (profile["Point"] /
                                                            (rank[index + 1][
                                                                "PointUpLevel"])),
                                                    color: mainColor),
                                              ),
                                              profile["Point"] == 0 ||
                                                      rank[index + 1]
                                                              ["PointUpLevel"] >
                                                          profile["Point"]
                                                  ? Text(
                                                      "Cần thêm ${rank[index + 1]["PointUpLevel"] - profile["Point"]} điểm để thăng hạng ${rank[index + 1]["CardName"]}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  : const Text(
                                                      "Bạn đã đủ điều kiện để đạt hạng này rồi",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
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
                                            "${e["Promotion"]}",
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
                                            "${e["Benefit"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ))
                                        ],
                                      ),
                                    )
                                  ])
                                ]);
                              }).toList()),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
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
