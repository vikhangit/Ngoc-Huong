import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/branchsModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:upgrader/upgrader.dart';

class ModalChiTietBooking extends StatefulWidget {
  final Map details;
  final Function? save;
  final String? status;
  final String? history;
  const ModalChiTietBooking(
      {super.key, required this.details, this.save, this.status, this.history});

  @override
  State<ModalChiTietBooking> createState() => _ModalChiTietBookingState();
}

class _ModalChiTietBookingState extends State<ModalChiTietBooking> {
  final ServicesModel servicesModel = ServicesModel();
  final BranchsModel branchsModel = BranchsModel();
  final BookingModel bookingModel = BookingModel();
  final CustomModal customModal = CustomModal();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    Map details =
        widget.history != null ? widget.details : widget.details["Data"];
    DateTime databook = DateTime.parse(details["StartDate"]);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
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
            body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            children: [
                              widget.history == null
                                  ? FutureBuilder(
                                      future: servicesModel.getServiceByName(
                                          details["ServiceList"][0].toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map detailProduct = snapshot.data!;
                                          print(detailProduct);
                                          return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: Image.network(
                                                      "${detailProduct["Image_Name"]}",
                                                      // height: 210,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          detailProduct["Name"],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 17),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        // Row(
                                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //   children: [
                                                        //     Text(
                                                        //       NumberFormat.currency(locale: "vi_VI", symbol: "đ")
                                                        //           .format(
                                                        //         detailProduct["PriceOutbound"],
                                                        //       ),
                                                        //       style: TextStyle(
                                                        //           fontSize: 16,
                                                        //           color: Theme.of(context).colorScheme.primary),
                                                        //     ),
                                                        //     // Row(
                                                        //     //   children: [
                                                        //     //     const Icon(
                                                        //     //       Icons.star,
                                                        //     //       size: 20,
                                                        //     //       color: Colors.orange,
                                                        //     //     ),
                                                        //     //     Container(
                                                        //     //       margin:
                                                        //     //       const EdgeInsets.symmetric(horizontal: 5),
                                                        //     //       child: const Text("4.8"),
                                                        //     //     ),
                                                        //     //     const Text(
                                                        //     //       "(130 đánh giá)",
                                                        //     //       style: TextStyle(fontWeight: FontWeight.w300),
                                                        //     //     )
                                                        //     //   ],
                                                        //     // )
                                                        //   ],
                                                        // ),
                                                        // const SizedBox(
                                                        //   height: 10,
                                                        // ),
                                                        const Text(
                                                          "Thông tin đặt lịch",
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Tháng ${databook.month < 10 ? "0${databook.month}" : databook.month}, ${databook.year}",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    Text(
                                                                      "${databook.day < 10 ? "0${databook.day}" : databook.day}",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              80),
                                                                    )
                                                                  ],
                                                                )),
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Container(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 4,
                                                                              horizontal: 15),
                                                                          decoration: BoxDecoration(
                                                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                          child:
                                                                              Text(
                                                                            widget!.status == null
                                                                                ? "Sắp tới"
                                                                                : "${details["Status"]}",
                                                                            style: TextStyle(
                                                                                color: Theme.of(context).colorScheme.primary,
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.w300),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/time-solid-black.png",
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          "${databook.hour}:${databook.minute}",
                                                                          style: const TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w300),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/location-solid-black.png",
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Flexible(
                                                                            child:
                                                                                Text(
                                                                          "${details["BranchInfo"]["Address"]}",
                                                                          style: const TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w300),
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ))
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                              ]);
                                        } else {
                                          return const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                          );
                                        }
                                      },
                                    )
                                  : FutureBuilder(
                                      future: servicesModel.getServiceByCode(
                                          widget.details["serviceList"][0]
                                              ["ServiceCode"]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map detailProduct = snapshot.data!;
                                          return Column(children: [
                                            Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  "${detailProduct["Image_Name"]}",
                                                  // height: 210,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      detailProduct["Name"],
                                                      style: const TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Text(
                                                        //   NumberFormat.currency(locale: "vi_VI", symbol: "đ")
                                                        //       .format(
                                                        //     detailProduct["PriceOutbound"],
                                                        //   ),
                                                        //   style: TextStyle(
                                                        //       fontSize: 16,
                                                        //       color: Theme.of(context).colorScheme.primary),
                                                        // ),
                                                        // Row(
                                                        //   children: [
                                                        //     const Icon(
                                                        //       Icons.star,
                                                        //       size: 20,
                                                        //       color: Colors.orange,
                                                        //     ),
                                                        //     Container(
                                                        //       margin:
                                                        //       const EdgeInsets.symmetric(horizontal: 5),
                                                        //       child: const Text("4.8"),
                                                        //     ),
                                                        //     const Text(
                                                        //       "(130 đánh giá)",
                                                        //       style: TextStyle(fontWeight: FontWeight.w300),
                                                        //     )
                                                        //   ],
                                                        // )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                      "Thông tin đặt lịch",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Tháng ${databook.month < 10 ? "0${databook.month}" : databook.month}, ${databook.year}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                Text(
                                                                  "${databook.day < 10 ? "0${databook.day}" : databook.day}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          80),
                                                                )
                                                              ],
                                                            )),
                                                            Expanded(
                                                                child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              4,
                                                                          horizontal:
                                                                              15),
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary
                                                                              .withOpacity(
                                                                                  0.2),
                                                                          borderRadius: const BorderRadius
                                                                              .all(
                                                                              Radius.circular(10))),
                                                                      child:
                                                                          Text(
                                                                        widget!.status ==
                                                                                null
                                                                            ? "Sắp tới"
                                                                            : "${widget.status}",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .colorScheme
                                                                                .primary,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w300),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/time-solid-black.png",
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "${DateFormat("HH:mm").format(databook)}",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/location-solid-black.png",
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    FutureBuilder(
                                                                      future: branchsModel
                                                                          .getBranchs(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (snapshot
                                                                            .hasData) {
                                                                          Map address = snapshot.data!.firstWhere(
                                                                              (e) => e["Name"] == details["BranchName"],
                                                                              orElse: () => null);
                                                                          print(
                                                                              address);
                                                                          return Flexible(
                                                                              child: Text(
                                                                            "${address["Address"]}",
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w300),
                                                                          ));
                                                                        } else {
                                                                          return Container();
                                                                        }
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ]);
                                        } else {
                                          return Container(
                                              margin: const EdgeInsets.only(
                                                  top: 60),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child: LoadingIndicator(
                                                      colors:
                                                          kDefaultRainbowColors,
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
                                    )
                            ],
                          ),
                        ),
                        if (widget.history != null &&
                            details["Status"] == "notyetarrived")
                          Container(
                            margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        20,
                                left: 15,
                                right: 15),
                            child: TextButton(
                                onPressed: () {
                                  customModal.showAlertDialog(
                                      context,
                                      "error",
                                      "Hủy Đặt Lịch",
                                      "Bạn có chắc chắn hủy đặt lịch này không?",
                                      () {
                                    Navigator.pop(context);
                                    EasyLoading.show(status: "Vui lòng chờ...");
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      bookingModel
                                          .cancelBookingService(details);
                                      bookingModel
                                          .getListBookinfStatus()
                                          .then((value) {
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          EasyLoading.dismiss();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookingHistory(
                                                        listAction: value,
                                                        ac: value.length - 2,
                                                      )));
                                          widget.save!();
                                        });
                                      });
                                    });
                                  }, () => Navigator.pop(context));
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 20))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Hủy đặt lịch",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Image.asset(
                                      "assets/images/calendar-white.png",
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                )),
                          )
                      ],
                    )))));
  }
}
