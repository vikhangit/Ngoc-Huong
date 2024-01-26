import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/ModalZoomImage.dart';
import 'package:ngoc_huong/screen/cosmetic/chi_tiet_san_pham.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:upgrader/upgrader.dart';

class ModalChiTietBuy extends StatefulWidget {
  final Map product;
  final String productInvoice;
  final Function? save;
  final int? ac;
  const ModalChiTietBuy(
      {super.key,
      required this.product,
      required this.productInvoice,
      this.save,
      this.ac});

  @override
  State<ModalChiTietBuy> createState() => _ModalChiTietBuyState();
}

int selectedIndex = 0;

class _ModalChiTietBuyState extends State<ModalChiTietBuy>
    with TickerProviderStateMixin {
  final OrderModel orderModel = OrderModel();
  final CustomModal customModal = CustomModal();
  final ScrollController scrollController = ScrollController();
  final ProfileModel profileModel = ProfileModel();
  final ServicesModel serviceModel = ServicesModel();
  final ProductModel productModel = ProductModel();
  final BookingModel bookingModel = BookingModel();

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime getPSTTime(DateTime now) {
      tz.initializeTimeZones();
      final pacificTimeZone = tz.getLocation('Asia/Ho_Chi_Minh');
      return tz.TZDateTime.from(now, pacificTimeZone);
    }

    List listSerive = widget.product["DetailList"]
        .where((x) => x["ProductType"] == "service")
        .toList();
    List listProduct = widget.product["DetailList"]
        .where((x) => x["ProductType"] == "product")
        .toList();
    // num totalBooking() {
    //   num total = 0;
    //   for (var i = 0; i < list.length; i++) {
    //     total += list[i]["Amount"];
    //   }
    //   return total;
    // }

    return SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: ScrollToHide(
            //     scrollController: scrollController,
            //     height: 100,
            //     child: const MyBottomMenu(
            //       active: 4,
            //     )),
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
              title: const Text("Chi tiết đơn hàng",
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
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/account/dia-chi.png",
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("Thông tin khách hàng",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black))
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Tên khách hàng",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: FutureBuilder(
                                  future: profileModel.getProfile(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!["CustomerName"],
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      );
                                    } else {
                                      return const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: LoadingIndicator(
                                              colors: kDefaultRainbowColors,
                                              indicatorType:
                                                  Indicator.lineSpinFadeLoader,
                                              strokeWidth: 1,
                                              // pathBackgroundColor: Colors.black45,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                  child: Text(
                                "Số điện thoại",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              )),
                              Expanded(
                                child: FutureBuilder(
                                  future: profileModel.getProfile(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!["Phone"],
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      );
                                    } else {
                                      return const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                        ],
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                  flex: 30,
                                  child: Text(
                                    "Địa chỉ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  )),
                              Expanded(
                                  flex: 70,
                                  child: Text(
                                    widget.product["BranchName"] ?? "",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ))
                            ],
                          )
                        ],
                      )),
                  FutureBuilder(
                      future: bookingModel
                          .getImageUsingBooking(widget.productInvoice),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/account/dieu-khoan.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Hình ảnh đơn hàng",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black))
                                    ],
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
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
                                child: snapshot.data!.isEmpty
                                    ? const Text(
                                        "Chưa có hình ảnh đơn hàng",
                                        textAlign: TextAlign.center,
                                      )
                                    : ImageDetail(
                                        items: snapshot.data!.toList()),
                              )
                            ],
                          );
                        } else {
                          return const SizedBox(
                            height: 120,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: LoadingIndicator(
                                  colors: kDefaultRainbowColors,
                                  indicatorType: Indicator.lineSpinFadeLoader,
                                  strokeWidth: 0.5,
                                  // pathBackgroundColor: Colors.black45,
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          margin: const EdgeInsets.only(right: 10, left: 15),
                          decoration: BoxDecoration(
                            color: selectedIndex == 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Text(
                            "Dịch vụ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: selectedIndex == 0
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      )),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            margin: const EdgeInsets.only(left: 10, right: 15),
                            decoration: BoxDecoration(
                              color: selectedIndex == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Text(
                              "Mỹ phẩm",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: selectedIndex == 1
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset:
                              const Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: selectedIndex == 1
                        ? listProduct.isNotEmpty
                            ? Column(
                                children: listProduct.map((item) {
                                int index = listProduct.indexOf(item);
                                return FutureBuilder(
                                  future: productModel
                                      .getProductCode(item["ProductCode"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map detail = snapshot.data!;
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetail(
                                                          details: detail)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: index != 0 ? 20 : 0),
                                          padding: EdgeInsets.only(
                                              top: index != 0 ? 10 : 0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: index != 0
                                                      ? const BorderSide(
                                                          width: 1,
                                                          color: Colors.grey)
                                                      : BorderSide.none)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  "${detail["Image_Name"] ?? "http://ngochuong.osales.vn/assets/css/images/noimage.gif"}",
                                                  errorBuilder: (context,
                                                      exception, stackTrace) {
                                                    return Image.network(
                                                      'http://ngochuong.osales.vn/assets/css/images/noimage.gif',
                                                      width: 110,
                                                      height: 110,
                                                      fit: BoxFit.cover,
                                                    );
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        "${item["ProductName"]}",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "${item["Quantity"] ?? 1}",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary)),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text("x",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary)),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                NumberFormat.currency(
                                                                        locale:
                                                                            "vi_VI",
                                                                        symbol:
                                                                            "")
                                                                    .format(
                                                                  item["Price"],
                                                                ),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary),
                                                              ),
                                                              Text(
                                                                "đ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    decorationColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox(
                                        height: 120,
                                        child: Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: LoadingIndicator(
                                              colors: kDefaultRainbowColors,
                                              indicatorType:
                                                  Indicator.lineSpinFadeLoader,
                                              strokeWidth: 0.5,
                                              // pathBackgroundColor: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }).toList())
                            : const Text(
                                "Chưa có đơn hàng",
                                textAlign: TextAlign.center,
                              )
                        : listSerive.isNotEmpty
                            ? Column(
                                children: listSerive.map((item) {
                                int index = listSerive.indexOf(item);
                                return FutureBuilder(
                                  future: serviceModel
                                      .getServiceByCode(item["ProductCode"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map detail = snapshot.data!;
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChiTietScreen(
                                                        detail: detail,
                                                      )));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: index != 0 ? 10 : 0),
                                          padding: EdgeInsets.only(
                                              top: index != 0 ? 10 : 0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: index != 0
                                                      ? const BorderSide(
                                                          width: 1,
                                                          color: Colors.grey)
                                                      : BorderSide.none)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  "${detail["Image_Name"] ?? "http://ngochuong.osales.vn/assets/css/images/noimage.gif"}",
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        "${item["ProductName"]}",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "${item["Quantity"] ?? 1}",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary)),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text("x",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary)),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                NumberFormat.currency(
                                                                        locale:
                                                                            "vi_VI",
                                                                        symbol:
                                                                            "")
                                                                    .format(
                                                                  item["Price"],
                                                                ),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary),
                                                              ),
                                                              Text(
                                                                "đ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    decorationColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      if (item[
                                                              "NgayHenTaiKham"] !=
                                                          null)
                                                        Text(
                                                          "Ngày tái khám: ${DateFormat("dd/MM/yyyy").format(DateTime.parse(item["NgayHenTaiKham"]))}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      if (item["Status"] !=
                                                              null &&
                                                          item["Status"] != "*")
                                                        Text(
                                                          "Tình trạng: ${item["Status"].toString().toLowerCase()}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                    ],
                                                  )
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox(
                                        height: 120,
                                        child: Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: LoadingIndicator(
                                              colors: kDefaultRainbowColors,
                                              indicatorType:
                                                  Indicator.lineSpinFadeLoader,
                                              strokeWidth: 0.5,
                                              // pathBackgroundColor: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }).toList())
                            : const Text(
                                "Chưa có đơn hàng",
                                textAlign: TextAlign.center,
                              ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(
                                4, 4), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/thanh-toan.png",
                              width: 28,
                              height: 28,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Phương thức thanh toán",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    "${widget.product["PaymentMethod"] ?? "Tiền mặt"} ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black45)),
                              ],
                            )
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_right_outlined,
                            color: Colors.black45)
                      ],
                    ),
                  ),
                  Container(
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Mã đơn hàng",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          Text("${widget.product["Code"]}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black))
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                  child: Text(
                                "Thời gian đặt hàng",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              )),
                              Text(
                                DateFormat("dd-MM-yyyy HH:mm").format(
                                    getPSTTime(DateTime.parse(
                                        widget.product["CreatedDate"]))),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            )));
  }
}

class ImageDetail extends StatefulWidget {
  final List items;
  const ImageDetail({super.key, required this.items});

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

int currentIndex = 0;

class _ImageDetailState extends State<ImageDetail> {
  final CarouselController carouselController = CarouselController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    List newList = widget.items;
    List<String> result =
        List.generate(newList.length, (index) => newList[index]["FilePath"]);
    List<Widget> imgList = List<Widget>.generate(
      newList.length,
      (index) => Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            // color: checkColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModalZoomImage(
                        currentIndex: currentIndex, imageList: result)));
          },
          child: Image.network(
            result[index],
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
    return SizedBox(
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
                      itemBuilder: (context, index, realIndex) =>
                          imgList[index]),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      controller: scrollController,
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
                              margin: EdgeInsets.only(left: index == 0 ? 0 : 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: currentIndex == index
                                        ? mainColor
                                        : Colors.white),
                              ),
                              child: Image.network(
                                e,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ));
                      }).toList(),
                    ),
                  )
                ],
              )
            : imgList.length == 1
                ? Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        // color: checkColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModalZoomImage(
                                    currentIndex: currentIndex,
                                    imageList: result)));
                      },
                      child: Image.network(
                        result[0],
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ))
                : Container());
  }
}
