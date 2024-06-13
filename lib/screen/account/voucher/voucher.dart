import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/account/voucher/voucherBuyDetail.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_chi_tiet_booking.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/screen/voucher_detail/voucher_detail.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class VoucherBuy extends StatefulWidget {
  final Map profile;
  const VoucherBuy({super.key, required this.profile});

  @override
  State<VoucherBuy> createState() => _VoucherBuyState();
}

int? _selectedIndex;

class _VoucherBuyState extends State<VoucherBuy> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final BannerModel bannerModel = BannerModel();
  final CustomModal customModal = CustomModal();
  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
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
      top: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: ScrollToHide(
              scrollController: scrollController,
              height: Platform.isAndroid ? 75 : 100,
              child: const MyBottomMenu(
                active: 4,
              )),
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountScreen()));
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
            title: const Text("Voucher của tôi",
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
              child: RefreshIndicator(
                onRefresh: () => refreshData(),
                child: FutureBuilder(
                  future: bannerModel.getVoucherBuy(widget.profile["Phone"]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.toList();
                      if (snapshot.data!.isNotEmpty) {
                        List arr = [];
                        for (var i = 0; i < list.length; i++) {
                          Map map = list[i]["details"].asMap();
                          for (var value in map.values)
                            arr.add({...value, "ngay": list[i]["ngay_ct"]});
                        }
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: arr.length,
                          itemBuilder: (context, index) {
                            return arr.isEmpty
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: index != 0 ? 20 : 30,
                                    ),
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
                                    height: 140,
                                    child: FutureBuilder(
                                      future: bannerModel.getVoucherByMaVoucher(
                                          arr[index]["ma_evoucher"]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map detail = snapshot.data!;
                                          DateTime now = DateTime.now();

                                          return TextButton(
                                              onPressed: () {
                                                if (DateTime.parse(
                                                        detail["hieu_luc_den"])
                                                    .isBefore(now)) {
                                                  customModal.showAlertDialog(
                                                      context,
                                                      "error",
                                                      "Lỗi mua voucher",
                                                      "Rất tiếc voucher này đã hết hạn sử dụng!!!",
                                                      () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      () =>
                                                          Navigator.of(context)
                                                              .pop());
                                                } else if (!detail["shared"]) {
                                                  customModal.showAlertDialog(
                                                      context,
                                                      "error",
                                                      "Lỗi mua voucher",
                                                      "Rất tiếc voucher này không còn được phát hành!!!",
                                                      () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      () =>
                                                          Navigator.of(context)
                                                              .pop());
                                                } else if (arr[index]
                                                        ["sl_xuat"] ==
                                                    0) {
                                                  customModal.showAlertDialog(
                                                      context,
                                                      "error",
                                                      "Lỗi mua voucher",
                                                      "Rất tiếc số lần dùng voucher đã hết!!!",
                                                      () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      () =>
                                                          Navigator.of(context)
                                                              .pop());
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VoucherBuyDetail(
                                                                detail: detail,
                                                                detail2:
                                                                    arr[index],
                                                              )));
                                                }
                                              },
                                              style: ButtonStyle(
                                                padding:
                                                    WidgetStateProperty.all(
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10,
                                                            horizontal: 8)),
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                        DateTime.parse(detail[
                                                                    "hieu_luc_den"])
                                                                .isBefore(now)
                                                            ? Colors
                                                                .grey.shade300
                                                            : Colors.white),
                                                shape: WidgetStateProperty.all(
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0)))),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: Image.network(
                                                      "$goodAppUrl${detail["banner1"]}?$token",
                                                      width: 110,
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      fit: BoxFit.cover,
                                                      color: DateTime.parse(detail[
                                                                  "hieu_luc_den"])
                                                              .isBefore(now)
                                                          ? Colors.white
                                                              .withOpacity(0.5)
                                                          : Colors.white,
                                                      colorBlendMode:
                                                          BlendMode.modulate,
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${detail["ten"]}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            height: 1.2,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: DateTime.parse(
                                                                        detail[
                                                                            "hieu_luc_den"])
                                                                    .isBefore(
                                                                        now)
                                                                ? Colors.grey
                                                                    .shade600
                                                                : Colors.black),
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
                                                      // const SizedBox(
                                                      //   height: 5,
                                                      // ),
                                                      // Row(
                                                      //   children: [
                                                      //     const Text(
                                                      //       "Đã thanh toán: ",
                                                      //       style: TextStyle(
                                                      //           color: Colors
                                                      //               .black,
                                                      //           fontSize: 12,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .w700),
                                                      //     ),
                                                      //     const SizedBox(
                                                      //       width: 2,
                                                      //     ),
                                                      // Expanded(
                                                      //   child: Text(
                                                      //     // list[index]["hinh_thuc_tt"] ==
                                                      //     //         "KHAC"
                                                      //     //     ? "Xu"
                                                      //     //     : list[index][
                                                      //     //                 "hinh_thuc_tt"] ==
                                                      //     //             "TM"
                                                      //     //         ? "Tiền mặt"
                                                      //     //         : ""
                                                      //     "${detail["giabanxu"]} xu",
                                                      //     style: const TextStyle(
                                                      //         color: Colors
                                                      //             .black,
                                                      //         fontSize: 12,
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .w500),
                                                      //   ),
                                                      // )
                                                      //     Row(
                                                      //       mainAxisAlignment:
                                                      //           MainAxisAlignment
                                                      //               .center,
                                                      //       children: [
                                                      //         Image.asset(
                                                      //           "assets/images/icon/Xu1.png",
                                                      //           width: 20,
                                                      //           height: 20,
                                                      //         ),
                                                      //         const SizedBox(
                                                      //           width: 3,
                                                      //         ),
                                                      //         Text(
                                                      //           "${detail["giabanxu"]}",
                                                      //           style: const TextStyle(
                                                      //               fontSize:
                                                      //                   12,
                                                      //               fontWeight:
                                                      //                   FontWeight
                                                      //                       .w500,
                                                      //               color: Colors
                                                      //                   .black),
                                                      //         ),
                                                      //       ],
                                                      //     )
                                                      //   ],
                                                      // ),
                                                      // Row(
                                                      //   children: [
                                                      //     Text(
                                                      //       "Số lần được dùng: ",
                                                      //       style: TextStyle(
                                                      //           color: DateTime.parse(detail[
                                                      //                       "hieu_luc_den"])
                                                      //                   .isBefore(
                                                      //                       now)
                                                      //               ? Colors
                                                      //                   .grey
                                                      //                   .shade600
                                                      //               : Colors
                                                      //                   .black,
                                                      //           fontSize: 12,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .w700),
                                                      //     ),
                                                      //     const SizedBox(
                                                      //       width: 2,
                                                      //     ),
                                                      //     Expanded(
                                                      //       child: Text(
                                                      //         "${detail["so_lan_sd"]} lần",
                                                      //         style: TextStyle(
                                                      //             color: DateTime.parse(detail[
                                                      //                         "hieu_luc_den"])
                                                      //                     .isBefore(
                                                      //                         now)
                                                      //                 ? Colors
                                                      //                     .grey
                                                      //                     .shade600
                                                      //                 : Colors
                                                      //                     .black,
                                                      //             fontSize: 12,
                                                      //             fontWeight:
                                                      //                 FontWeight
                                                      //                     .w500),
                                                      //       ),
                                                      //     )
                                                      //   ],
                                                      // ),

                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Số lần được dùng: ",
                                                            style: TextStyle(
                                                                color: DateTime.parse(detail[
                                                                            "hieu_luc_den"])
                                                                        .isBefore(
                                                                            now)
                                                                    ? Colors
                                                                        .grey
                                                                        .shade600
                                                                    : Colors
                                                                        .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              arr[index][
                                                                      "sl_xuat"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: DateTime.parse(detail[
                                                                              "hieu_luc_den"])
                                                                          .isBefore(
                                                                              now)
                                                                      ? Colors
                                                                          .grey
                                                                          .shade600
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Ngày mua: ",
                                                            style: TextStyle(
                                                                color: DateTime.parse(detail[
                                                                            "hieu_luc_den"])
                                                                        .isBefore(
                                                                            now)
                                                                    ? Colors
                                                                        .grey
                                                                        .shade600
                                                                    : Colors
                                                                        .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "${DateFormat("dd/MM/yyyy").format(DateTime.parse(arr[index]["ngay"]))}",
                                                              style: TextStyle(
                                                                  color: DateTime.parse(detail[
                                                                              "hieu_luc_den"])
                                                                          .isBefore(
                                                                              now)
                                                                      ? Colors
                                                                          .grey
                                                                          .shade600
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          )
                                                        ],
                                                      ),

                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Hết hạn: ",
                                                            style: TextStyle(
                                                                color: DateTime.parse(detail[
                                                                            "hieu_luc_den"])
                                                                        .isBefore(
                                                                            now)
                                                                    ? Colors
                                                                        .grey
                                                                        .shade600
                                                                    : Colors
                                                                        .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "${DateFormat("dd/MM/yyyy").format(DateTime.parse(detail["hieu_luc_den"]))}",
                                                              style: TextStyle(
                                                                  color: DateTime.parse(detail[
                                                                              "hieu_luc_den"])
                                                                          .isBefore(
                                                                              now)
                                                                      ? Colors
                                                                          .grey
                                                                          .shade600
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                                ],
                                              ));
                                        } else {
                                          return const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: LoadingIndicator(
                                                colors: kDefaultRainbowColors,
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
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
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 40, bottom: 15),
                              child:
                                  Image.asset("assets/images/account/img.webp"),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Text(
                                "Bạn chưa có voucher đã mua. Hãy mua voucher ngay hôm nay để nhận được nhiều ưu đãi",
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
              ))),
    );
  }
}
