import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_chi_tiet_booking.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';

class BookingHistory extends StatefulWidget {
  final int? ac;
  const BookingHistory({super.key, this.ac});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

int? _selectedIndex;

class _BookingHistoryState extends State<BookingHistory>
    with TickerProviderStateMixin {
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
    bookingModel.getListBookinfStatus().then((value) =>  tabController = TabController(length: value.length, vsync: this));
    if (widget.ac != null) {
      tabController?.animateTo(widget.ac!);
    } else {
      tabController?.addListener(_getActiveTabIndex);
    }
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: const MyBottomMenu(
            active:4,
          ),
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
            title: const Text("Lịch sử đặt lịch",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          body: FutureBuilder(
            future: bookingModel.getListBookinfStatus(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
               return ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TabBar(
                        controller: tabController,
                        isScrollable: true,
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: "LexendDeca"),
                        onTap: (tabIndex) {
                          setState(() {
                            _selectedIndex = tabIndex;
                          });
                        },
                        tabs: snapshot.data!.map((item) => SizedBox(
                          width: MediaQuery.of(context).size.width / 3 - 35,
                          child: Tab(
                            text: "${item["GroupName"]}",
                          ),
                        ),).toList()
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 250,
                      child: TabBarView(
                        controller: tabController,
                        children: snapshot.data!.map((i){
                          if(snapshot.hasData){
                          return FutureBuilder(
                              future: bookingModel.getBookingListByStatusCode(i["GroupCode"]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List list = snapshot.data!.reversed.toList();
                                  if (snapshot.data!.isNotEmpty) {
                                    return RefreshIndicator(
                                      onRefresh: refreshData,
                                      child: ListView.builder(
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          DateTime databook = DateTime.parse(list[index]["StartDate"]);
                                          return list[index]["serviceList"].isEmpty ? Container() : Container(
                                            margin: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: index != 0 ? 20 : 30,
                                                bottom: index == list.length - 1
                                                    ? 20
                                                    : 0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(4,
                                                      4), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            height: 125,
                                            child:
                                            FutureBuilder(
                                              future: servicesModel.getServiceByName(list[index]["serviceList"][0]["ServiceName"]),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  Map detail = snapshot.data!;
                                                  return TextButton(
                                                      onPressed: () {
                                                        showModalBottomSheet<void>(
                                                            backgroundColor:
                                                            Colors.white,
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            context: context,
                                                            isScrollControlled: true,
                                                            builder: (BuildContext
                                                            context) {
                                                              return Container(
                                                                  padding: EdgeInsets.only(
                                                                      bottom: MediaQuery.of(
                                                                          context)
                                                                          .viewInsets
                                                                          .bottom),
                                                                  height: MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.8,
                                                                  child:
                                                                  ModalChiTietBooking(
                                                                    details: list[index],
                                                                    history: "1",
                                                                    status: i["GroupName"],
                                                                  ));
                                                            });
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
                                                                    Radius
                                                                        .circular(
                                                                        10)))),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                            child: Image.network(
                                                              "${detail["Image_Name"]}",
                                                              width: 110,
                                                              height: MediaQuery.of(context).size.height,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "${detail["Name"]}",
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    maxLines: 2,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
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
                                                                  const SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        "assets/images/time-solid-black.png",
                                                                        width: 20,
                                                                        height: 20,
                                                                        fit: BoxFit.contain,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Expanded(child: Text(DateFormat("HH:mm").format(databook),
                                                                        style: const TextStyle(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w300),),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 5,),
                                                                  Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        "assets/images/calendar-solid-black.png",
                                                                        width: 20,
                                                                        height: 20,
                                                                        fit: BoxFit.contain,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Expanded(child: Text(DateFormat("dd/MM/yyyy").format(databook),
                                                                        style: const TextStyle(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w300),),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      ));
                                                } else {
                                                  return const Center(
                                                    child:
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
                                          margin: const EdgeInsets.only(
                                              top: 40, bottom: 15),
                                          child: Image.asset(
                                              "assets/images/account/img.webp"),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: const Text(
                                            "Bạn chưa đặt lịch. Hãy đặt lịch ngày hôm nay để nhận được nhiều ưu đãi",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                } else {
                                  return const Row(
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
                                  );
                                }
                              },
                            );
                          }else{
                            return const Center(
                              child:
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
                            );
                          }
                        }).toList(),
                      ),
                    )
                  ],
                );
              }
              else{
                return const Center(
                  child:
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
                );
              }
            },
          )),
    );
  }
}
