import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/checkinModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/booking/modal/modal_dia_chi.dart';
import 'package:ngoc_huong/screen/cart/cart.dart';
import 'package:ngoc_huong/screen/check_in/CheckIn.dart';
import 'package:ngoc_huong/screen/cosmetic/cosmetic.dart';
import 'package:ngoc_huong/screen/gift_shop/gift_shop.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/member/thanh_vien.dart';
import 'package:ngoc_huong/screen/news/tin_tuc.dart';
import 'package:ngoc_huong/screen/notifications/notification.dart';
import 'package:ngoc_huong/screen/services/all_service.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class ActionHome extends StatefulWidget {
  const ActionHome({super.key});

  @override
  State<ActionHome> createState() => _ActionHomeState();
}

List toolServices = [
  {"icon": "assets/images/icon/icon1.png", "title": "Đặt lịch"},
  {"icon": "assets/images/icon/icon-vi-tri.jpg", "title": "Tìm địa chỉ"},
  {"icon": "assets/images/icon/dich-vu.png", "title": "Dịch vụ làm đẹp"},
  {"icon": "assets/images/icon/my-pham.png", "title": "Mỹ phẩm cao cấp"},
  {"icon": "assets/images/icon/gift.png", "title": "Shop Quà Tặng"},
];

bool showMore = false;
int count = 0;

class _ActionHomeState extends State<ActionHome> {
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final ProfileModel profileModel = ProfileModel();
  final BookingModel bookingModel = BookingModel();
  final CartModel cartModel = CartModel();
  final CustomModal customModal = CustomModal();
  final CheckInModel checkInModel = CheckInModel();
  final ServicesModel servicesModel = ServicesModel();
  final ProductModel productModel = ProductModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    showMore = false;
  }

  void goToService(BuildContext context, int index) {
    if(index == 2){
      servicesModel
                  .getGroupServiceByBranch()
                  .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllServiceScreen(
                                listTab: value,
                              ))));
              
    }else if(index == 3){
      productModel.getGroupProduct().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Cosmetic(
                              listTab: value,
                            )))
                // print(value)
                );
          
    }else if (storageCustomerToken.getItem("customer_token") != null) {
      switch (index) {
        case 0:
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookingServices()));
            break;
          }
        case 1:
          {
            showModalBottomSheet<void>(
                backgroundColor: Colors.white,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      height: MediaQuery.of(context).size.height * .96,
                      child: ModalDiaChi(saveCN: () => setState(() {})));
                });
            break;
          }
          
        case 4:
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const GiftShop()));
            break;
          }
        // case 7:
        //   {
        //     orderModel.getStatusList().then((value) => Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => BuyHistory(
        //               listTab: value,
        //             ))));
        //
        //     break;
        //   }
        default:
          {
            break;
          }
      }
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  Widget checkRank(int point) {
    if (point == 0 && point < 100) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(
                        ac: 0,
                      )));
        },
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(99999)),
            gradient: LinearGradient(
                begin: Alignment(0.7658354043960571, 0.2429373413324356),
                end: Alignment(-0.24266093969345093, 0.25175198912620544),
                colors: [
                  Color.fromRGBO(171, 171, 171, 1),
                  Color.fromRGBO(223, 223, 223, 1),
                  Color.fromRGBO(196, 196, 196, 1),
                  Color.fromRGBO(184, 184, 184, 1)
                ]),
          ),
          child: const Text(
            "Thành viên bạc >",
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      );
    } else if (point >= 100 && point < 250) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(
                        ac: 1,
                      )));
        },
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(99999)),
            gradient: LinearGradient(
                begin: Alignment(0.7658354043960571, 0.2429373413324356),
                end: Alignment(-0.24266093969345093, 0.25175198912620544),
                colors: [
                  Color.fromRGBO(222, 193, 161, 1),
                  Color.fromRGBO(251, 236, 215, 1),
                  Color.fromRGBO(245, 223, 199, 1),
                  Color.fromRGBO(213, 181, 156, 1)
                ]),
          ),
          child: const Text(
            "Thành viên vàng >",
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      );
    } else if (point >= 250 && point < 500) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(
                        ac: 2,
                      )));
        },
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(99999)),
            gradient: LinearGradient(
                begin: Alignment(0.7658354043960571, 0.2429373413324356),
                end: Alignment(-0.24266093969345093, 0.25175198912620544),
                colors: [
                  Color.fromRGBO(114, 137, 221, 1),
                  Color.fromRGBO(208, 218, 255, 1),
                  Color.fromRGBO(171, 187, 247, 1),
                  Color.fromRGBO(126, 149, 232, 1)
                ]),
          ),
          child: const Text(
            "Thành viên bạch kim >",
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      );
    } else if (point >= 500) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(ac: 3)));
        },
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(99999)),
            gradient: LinearGradient(
                begin: Alignment(0.7658354043960571, 0.2429373413324356),
                end: Alignment(-0.24266093969345093, 0.25175198912620544),
                colors: [
                  Color.fromRGBO(107, 218, 207, 1),
                  Color.fromRGBO(208, 252, 255, 1),
                  Color.fromRGBO(171, 234, 247, 1),
                  Color.fromRGBO(126, 229, 232, 1)
                ]),
          ),
          child: const Text(
            "Thành viên kim cương >",
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(99999)),
        gradient: LinearGradient(
            begin: Alignment(0.7658354043960571, 0.2429373413324356),
            end: Alignment(-0.24266093969345093, 0.25175198912620544),
            colors: [
              Color.fromRGBO(171, 171, 171, 1),
              Color.fromRGBO(223, 223, 223, 1),
              Color.fromRGBO(196, 196, 196, 1),
              Color.fromRGBO(184, 184, 184, 1)
            ]),
      ),
      child: const Text(
        "Thành viên bạc >",
        style: TextStyle(
            fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 0.5, color: Colors.black38))),
                  child: storageCustomerToken.getItem("customer_token") != null
                      ? FutureBuilder(
                          future: profileModel.getProfile(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Map profile = snapshot.data!;
                              print(profile["Point"]);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              backgroundColor: Colors.black,
                                              insetPadding:
                                                  const EdgeInsets.all(20),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 350,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "${profile["CustomerImage"]}"),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color(0xff00A3FF),
                                            backgroundImage: NetworkImage(
                                                "${profile["CustomerImage"]}"),
                                            radius: 35.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hi, ${profile["CustomerName"].toString().toUpperCase()}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: mainColor),
                                          ),
                                          checkRank(profile["Point"] ?? 0)
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${profile["Point"] ?? 0} điểm",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: mainColor),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "150 xu",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w600,
                                                    color: mainColor),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Image.asset(
                                                "assets/images/icon/Xu.png",
                                                width: 12,
                                                height: 12,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      FutureBuilder(
                                        future: cartModel.getProductCartList(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 2,
                                                    offset: const Offset(0,
                                                        2), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (contex) =>
                                                              CartScreen()));
                                                },
                                                child: Image.asset(
                                                  "assets/images/icon/cart.png",
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: LoadingIndicator(
                                                colors: kDefaultRainbowColors,
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
                                                strokeWidth: 1,
                                                // pathBackgroundColor: Colors.black45,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      FutureBuilder(
                                        future: bookingModel.getNotifications(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List list = snapshot.data!
                                                .toList()
                                                .where((e) =>
                                                    e["IsRead"] == null ||
                                                    !e["IsRead"])
                                                .toList();
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 2,
                                                    offset: const Offset(0,
                                                        2), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    if (storageCustomerToken
                                                            .getItem(
                                                                "customer_token") !=
                                                        null) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const NotificationScreen()));
                                                    } else {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoginScreen()));
                                                    }
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Icon(
                                                        Icons.notifications,
                                                        color: mainColor,
                                                      ),
                                                      Positioned(
                                                          right: 0,
                                                          top: 4,
                                                          child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white),
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 10,
                                                                height: 10,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(1),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color:
                                                                        mainColor),
                                                                child: Text(
                                                                    "${list.length}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            6,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w400)),
                                                              )))
                                                    ],
                                                  )),
                                            );
                                          } else {
                                            return const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: LoadingIndicator(
                                                colors: kDefaultRainbowColors,
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
                                                strokeWidth: 1,
                                                // pathBackgroundColor: Colors.black45,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              );
                            } else {
                              return const SizedBox(
                                width: 30,
                                height: 30,
                                child: LoadingIndicator(
                                  colors: kDefaultRainbowColors,
                                  indicatorType: Indicator.lineSpinFadeLoader,
                                  strokeWidth: 1,
                                  // pathBackgroundColor: Colors.black45,
                                ),
                              );
                            }
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen())),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "Đăng nhập",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  )),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (contex) =>
                                                  const LoginScreen()));
                                    },
                                    child: Image.asset(
                                      "assets/images/icon/cart.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                      onTap: () {
                                        if (storageCustomerToken
                                                .getItem("customer_token") !=
                                            null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const NotificationScreen()));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen()));
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Icon(
                                            Icons.notifications,
                                            color: mainColor,
                                          ),
                                          Positioned(
                                              right: 0,
                                              top: 4,
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 10,
                                                    height: 10,
                                                    margin:
                                                        const EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: mainColor),
                                                    child: const Text("0",
                                                        style: TextStyle(
                                                            fontSize: 6,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  )))
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ],
                        )),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: toolServices.map((item) {
                    int index = toolServices.indexOf(item);
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 5 - 22,
                      // height:90,
                      child: TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0))),
                        onPressed: () {
                          goToService(context, index);
                        },
                        child: Column(
                          children: [
                            index == 1
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      width: 48,
                                      height: 48,
                                      "${item["icon"]}",
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 6),
                                    child: Image.asset(
                                      width: 35,
                                      height: 35,
                                      "${item["icon"]}",
                                    ),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${item["title"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
