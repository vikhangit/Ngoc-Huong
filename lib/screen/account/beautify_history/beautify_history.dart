import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_chi_tiet_booking.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class BeautifyHistory extends StatefulWidget {
  final int? ac;
  final List listAction;
  const BeautifyHistory({super.key, this.ac, required this.listAction});

  @override
  State<BeautifyHistory> createState() => _BeautifyHistoryState();
}

int? _selectedIndex;

class _BeautifyHistoryState extends State<BeautifyHistory>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  TabController? tabController;
  final BookingModel bookingModel = BookingModel();
  final ServicesModel servicesModel = ServicesModel();
  void _getActiveTabIndex() {
    setState(() {
      _selectedIndex = tabController!.index;
    });
  }

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    tabController =
        TabController(length: widget.listAction.length, vsync: this);
    if (widget.ac != null) {
      tabController?.animateTo(widget.ac!);
    } else {
      tabController?.addListener(_getActiveTabIndex);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: ScrollToHide(
              scrollController: scrollController,
              height: 100,
              child: const MyBottomMenu(
                active: 4,
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
            title: const Text("Lịch sử tham gia dịch vụ",
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
              future: bookingModel.getUsingBooking(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data!.reversed.toList();
                  if (snapshot.data!.isNotEmpty) {
                    return RefreshIndicator(
                      onRefresh: refreshData,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return list.isEmpty
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: index != 0 ? 20 : 30,
                                      bottom:
                                          index == list.length - 1 ? 20 : 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                  child: FutureBuilder(
                                    future: servicesModel.getServiceByCode(
                                        list[index]["ServiceCode"]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Map detail = snapshot.data!;
                                        return TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChiTietScreen(
                                                              detail: detail)));
                                            },
                                            style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10,
                                                          horizontal: 8)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all(
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)))),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: Image.network(
                                                    "${detail["Image_Name"]}",
                                                    errorBuilder: (context,
                                                        exception, stackTrace) {
                                                      return Image.network(
                                                          width: 110,
                                                          height: 110,
                                                          fit: BoxFit.cover,
                                                          'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
                                                    },
                                                    width: 110,
                                                    height: 110,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${detail["Name"]}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black),
                                                    ),
                                                    // Container(
                                                    //     margin:
                                                    //     const EdgeInsets
                                                    //         .only(
                                                    //         bottom:
                                                    //         0,
                                                    //         top: 5),
                                                    //     child: Html(
                                                    //         style: {
                                                    //           "*": Style(
                                                    //               margin: Margins.only(
                                                    //                   top:
                                                    //                   0,
                                                    //                   left:
                                                    //                   0),
                                                    //               maxLines:
                                                    //               2,
                                                    //               fontSize: FontSize(
                                                    //                   14),
                                                    //               fontWeight: FontWeight
                                                    //                   .w300,
                                                    //               textOverflow:
                                                    //               TextOverflow.ellipsis),
                                                    //         },
                                                    //         data: "")),
                                                    // const SizedBox(height: 5,),
                                                    //  Text(
                                                    //    NumberFormat.currency(
                                                    //        locale:
                                                    //        "vi_VI",
                                                    //        symbol:
                                                    //        "đ")
                                                    //        .format(
                                                    //        detail["PriceOutbound"],
                                                    //    ),
                                                    //   style: const TextStyle(
                                                    //     color: Colors.black
                                                    //   ),
                                                    //  ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            "Số lần thực hiện",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black)),
                                                        Text(
                                                            "${list[index]["QuantityUsed"]}/${list[index]["Quantity"]}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black))
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    if (list[index]
                                                                ["DetailList"]
                                                            [0]["Status"] !=
                                                        null)
                                                      Text(
                                                        "Tình trạng: ${list[index]["DetailList"][0]["Status"].toString().toLowerCase()}",
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                  ],
                                                ))
                                              ],
                                            ));
                                      } else {
                                        return const SizedBox(
                                          height: 120,
                                          child: Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: LoadingIndicator(
                                                colors: kDefaultRainbowColors,
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
                                                strokeWidth: 0.5,
                                                // pathBackgroundColor: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                        },
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 40, bottom: 15),
                          child: Image.asset("assets/images/account/img.webp"),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            "Bạn chưa đặt lịch. Hãy đặt lịch ngày hôm nay để nhận được nhiều ưu đãi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    );
                  }
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
          )),
    );
  }
}
