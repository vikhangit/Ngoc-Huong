import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class ChiTietScreen extends StatefulWidget {
  final Map detail;
  const ChiTietScreen({super.key, required this.detail});

  @override
  State<ChiTietScreen> createState() => _ChiTietScreenState();
}

int? _selectedIndex;

int starLength = 5;
double _rating = 0;
int activeTab = 1;

class _ChiTietScreenState extends State<ChiTietScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
    setState(() {
      activeTab = 1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    activeTab = 1;
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  void save() {
    setState(() {});
  }

  void goToTab(int index) {
    setState(() {
      activeTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    Map detail = widget.detail;
    print(detail);
    return SafeArea(
      bottom: false,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          // bottomNavigationBar: ScrollToHide(
          //     scrollController: scrollController,
          //     height: 100,
          //     child: const MyBottomMenu(
          //       active: 0,
          //     )),
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
            title: const Text("Chi tiết dịch vụ",
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: detail["ImageList"].toList().length > 0
                              ? ImageDetail(
                                  item: detail,
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      // color: checkColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Image.network(
                                    "${detail["Image_Name"]}",
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, exception, stackTrace) {
                                      return Image.network(
                                          fit: BoxFit.cover,
                                          'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
                                    },
                                  ),
                                ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  detail["Name"],
                                  style: const TextStyle(fontSize: 17),
                                ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       NumberFormat.currency(
                                //           locale: "vi_VI", symbol: "")
                                //           .format(
                                //         detail["PriceOutbound"],
                                //       ),
                                //       style: TextStyle(
                                //           fontSize: 15,
                                //           color: Theme.of(context)
                                //               .colorScheme
                                //               .primary),
                                //     ),
                                //     Text(
                                //       "đ",
                                //       style: TextStyle(
                                //         color:
                                //         Theme.of(context).colorScheme.primary,
                                //         fontSize: 15,
                                //         decoration: TextDecoration.underline,
                                //       ),
                                //     )
                                //   ],
                                // ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  "Thông tin dịch vụ",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: activeTab == 1
                                            ? BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)
                                            : BorderSide.none)),
                                child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(0))),
                                  onPressed: () => goToTab(1),
                                  child: Text(
                                    "Chi tiết dịch vụ",
                                    style: TextStyle(
                                        color: activeTab == 1
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.black),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: activeTab == 2
                                            ? BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)
                                            : BorderSide.none)),
                                child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(0))),
                                  onPressed: () => goToTab(2),
                                  child: Text("Đánh giá dịch vụ",
                                      style: TextStyle(
                                          color: activeTab == 2
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.black)),
                                ),
                              ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                if (activeTab == 1)
                                  Html(
                                    data: detail["Description"] ?? "",
                                    style: {
                                      "*": Style(margin: Margins.only(left: 0)),
                                      "p": Style(
                                          lineHeight: const LineHeight(1.8),
                                          fontSize: FontSize(15),
                                          fontWeight: FontWeight.w300,
                                          textAlign: TextAlign.justify),
                                      "img": Style(margin: Margins.only(top: 5))
                                      //   "img": Style(
                                      //     width: Width(MediaQuery.of(context).size.width * .85),
                                      //     margin: Margins.only(top: 10, bottom: 6, left: 15, right: 0),
                                      //     textAlign: TextAlign.center
                                      //   )
                                    },
                                  ),
                                if (activeTab == 2)
                                  const SizedBox(
                                      child: Text(
                                    "Chúng tôi đang nâng cấp tính năng này",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  )),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 30, left: 15, right: 15, top: 30),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 20)),
                                ),
                                onPressed: () {
                                  makingPhoneCall();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Điện thoại nhận tư vấn",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Image.asset(
                                      "assets/images/call-black.png",
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.only(top: 15),
                            child: TextButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 20)),
                                    shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.4))),
                                onPressed: () {
                                  if (storageCustomerToken
                                          .getItem("customer_token") ==
                                      null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BookingServices(
                                                  dichvudachon: detail,
                                                )));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Đặt lịch hẹn",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(width: 15),
                                    Image.asset(
                                      "assets/images/calendar-black.png",
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}

class ImageDetail extends StatefulWidget {
  final Map item;
  const ImageDetail({super.key, required this.item});

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

int currentIndex = 0;

class _ImageDetailState extends State<ImageDetail> {
  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    List newList = [
      widget.item["ImageList"][0]["Image_Name"],
      widget.item["ImageList"][0]["Image_Name2"],
      widget.item["ImageList"][0]["Image_Name3"],
      widget.item["ImageList"][0]["Image_Name4"],
      widget.item["ImageList"][0]["Image_Name5"]
    ];
    List result = [];
    for (var x in newList) {
      if (!["", null, false, 0].contains(x)) {
        result.add(x);
      }
    }
    print(result);
    List<Widget> imgList = List<Widget>.generate(
      result.length,
      (index) => Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            // color: checkColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Image.network(
          "${result[index]}",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fitHeight,
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: (imgList.length > 1)
          ? Column(
              children: [
                CarouselSlider.builder(
                    carouselController: carouselController,
                    options: CarouselOptions(
                      aspectRatio: 2,
                      height: 380,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    itemCount: imgList.length,
                    itemBuilder: (context, index, realIndex) => imgList[index]),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: result.map((e) {
                    int index = result.indexOf(e);
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                            carouselController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: index == 1 ? 5 : 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: currentIndex == index
                                    ? mainColor
                                    : Colors.white),
                          ),
                          child: Image.network(
                            e,
                            width: 80,
                            height: 80,
                          ),
                        ));
                  }).toList(),
                )
              ],
            )
          : imgList.length == 1
              ? Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      // color: checkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Image.network(
                    "${result[0]}",
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      // color: checkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Image.network(
                    "${widget.item["Image_Name"]}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, exception, stackTrace) {
                      return Image.network(
                          fit: BoxFit.cover,
                          'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
                    },
                  ),
                ),
    );
  }
}
