import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/screen/account/buy_history/buy_history.dart';
import 'package:ngoc_huong/screen/account/buy_history/modal_chi_tiet_buy.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class CheckoutSuccess extends StatefulWidget {
  const CheckoutSuccess({super.key});

  @override
  State<CheckoutSuccess> createState() => _CheckoutSuccessState();
}

double circleSize = 140;
double iconSize = 108;
bool loading = true;

class _CheckoutSuccessState extends State<CheckoutSuccess>
    with TickerProviderStateMixin {
  final OrderModel orderModel = OrderModel();
  late AnimationController scaleController = AnimationController(
      duration: const Duration(milliseconds: 800), vsync: this);
  late Animation<double> scaleAnimation =
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(
      duration: const Duration(milliseconds: 600), vsync: this);
  late Animation<double> checkAnimation =
      CurvedAnimation(parent: checkController, curve: Curves.linear);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    scrollController.dispose();
    loading = true;
    super.dispose();
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
              title: const Text("Thông báo",
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
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            Center(
                              child: Stack(
                                children: [
                                  ScaleTransition(
                                    scale: scaleAnimation,
                                    child: Container(
                                      height: circleSize,
                                      width: circleSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width)),
                                          border: Border.all(
                                              width: 3, color: Colors.green)),
                                    ),
                                  ),
                                  SizeTransition(
                                    sizeFactor: checkAnimation,
                                    axis: Axis.horizontal,
                                    axisAlignment: -1,
                                    child: Container(
                                      height: circleSize,
                                      width: circleSize,
                                      alignment: Alignment.center,
                                      child: Icon(Icons.check,
                                          color: Colors.green, size: iconSize),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "Đặt hàng thành công!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              child: Text(
                                "Chúc mừng bạn đã đặt hàng thành công. Hãy đến với Ngọc Hường để có những trãi nghiệm tốt nhất",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: orderModel.getOrderListByStatus("pending"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List list = snapshot.data!.toList();
                              return FutureBuilder(
                                future: orderModel.getStatusList(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return GestureDetector(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: Colors.grey),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text("Xem chi tiết",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Image.asset(
                                                "assets/images/cart-black.png",
                                                width: 24,
                                                height: 24,
                                                fit: BoxFit.fill,
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BuyHistory(
                                                          listTab:
                                                              snapshot.data!)));
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModalChiTietBuy(
                                                          product: list[
                                                              list.length - 1],
                                                          type: "")));
                                        });
                                  } else {
                                    return Container();
                                  }
                                },
                              );
                            } else {
                              return const Center(
                                child: SizedBox(
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
                      ],
                    )))));
  }
}
