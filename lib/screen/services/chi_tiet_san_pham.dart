import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';
import 'package:ngoc_huong/screen/services/cart_success.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ProductDetail extends StatefulWidget {
  final Map details;
  const ProductDetail({
    super.key,
    required this.details,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

List cartItem = [];
int choose = 0;
int? _selectedIndex;
int? _selectedIndex2;
int quantity = 1;
int starLength = 5;
double _rating = 0;

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  LocalStorage storage = LocalStorage('auth');
  LocalStorage storageToken = LocalStorage('token');
  LocalStorage storageCN = LocalStorage("chi_nhanh");
  TabController? tabController;
  TabController? tabController2;
  @override
  void initState() {
    super.initState();
    setState(() {
      quantity = 1;
    });
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
    tabController2 = TabController(
        length: widget.details["picture4"] != null
            ? 4
            : widget.details["picture3"] != null
                ? 3
                : widget.details["picture2"] != null
                    ? 2
                    : 1,
        vsync: this);
    tabController2?.addListener(_getActiveTabIndex2);
  }

  @override
  void dispose() {
    quantity = 1;
    super.dispose();
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  void _getActiveTabIndex2() {
    _selectedIndex2 = tabController2?.index;
  }

  void showAlertDialog(BuildContext context, String err) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.pop(context, 'OK'),
    );
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return SizedBox(
            // height: 30,
            width: MediaQuery.of(context).size.width,
            child: Text(
              style: const TextStyle(height: 1.6),
              err,
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map productDetail = widget.details;
    Map chiNhanh = jsonDecode(storageCN.getItem("chi_nhanh"));
    void addToCart() async {
      if (quantity <= 0) {
        showAlertDialog(context, "Số lượng phải lớn hơn 0");
      } else {
        Map data = {
          "ma_vt": widget.details["ma_vt"],
          "ma_dvt": widget.details["ma_dvt"],
          "sl_xuat": quantity,
          "gia_ban": widget.details["gia_ban_le"],
          "gia_ban_le0": widget.details["gia_ban_le"],
          "gia_ban_nt": widget.details["gia_ban_le"],
        };
        await postCart(data).then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddCartSuccess())));
      }
    }

    void updateCart(String id, int qty) async {
      if (quantity <= 0) {
        showAlertDialog(context, "Số lượng phải lớn hơn 0");
      } else {
        Map data = {"sl_xuat": qty};
        await putCart(id, data).then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddCartSuccess())));
      }
    }

    void onLoadingAdd() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        addToCart();
        Navigator.pop(context);
      });
    }

    void onLoadingUpdate(String id, int qty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        updateCart(id, qty);
        Navigator.pop(context); //pop dialog
      });
    }

    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30))),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        width: 36,
                        height: 36,
                        child: const Icon(
                          Icons.west,
                          size: 16,
                          color: Colors.black,
                        ),
                      )),
                ),
                const Expanded(
                  flex: 84,
                  child: Center(
                    child: Text(
                      "Chi tiết sản phẩm",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: const EdgeInsets.only(bottom: 5),
            height: MediaQuery.of(context).size.height * 0.95 -
                195 -
                MediaQuery.of(context).viewInsets.bottom,
            child: ListView(
              children: [
                pictureProduct(context, productDetail),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "${productDetail["ten_vt"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Wrap(
                        children: [
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.orange,
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.orange,
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.orange,
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.orange,
                          ),
                          Icon(
                            Icons.star_half,
                            size: 20,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "4.8",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[700],
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            NumberFormat.currency(locale: "vi_VI", symbol: "")
                                .format(
                              productDetail["gia_ban_le"],
                            ),
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Text(
                            "đ",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                quantity--;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.orange),
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.remove,
                                size: 20,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "$quantity",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.orange),
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // infomation()
                ]),
                infomation(productDetail["mieu_ta"]),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 20)),
                      ),
                      onPressed: () {
                        makingPhoneCall(chiNhanh["exfields"]["dien_thoai"]);
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
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 15),
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 20)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4))),
                      onPressed: () {
                        if (storage.getItem("existAccount") != null &&
                            storageToken.getItem("token") != null) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                content: Builder(
                                  builder: (context) {
                                    return SizedBox(
                                        // height: 30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.info,
                                              size: 70,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Text(
                                              "Thêm sản phẩm vào giỏ hàng",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "Bạn có muốn thêm sản phẩm vào giỏ hàng không?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        ));
                                  },
                                ),
                                actionsPadding: const EdgeInsets.only(
                                    top: 0, left: 30, right: 30, bottom: 30),
                                actions: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: FutureBuilder(
                                      future: callCartApiByName(
                                          productDetail["ma_vt"]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return TextButton(
                                            onPressed: () {
                                              if (snapshot.data!
                                                  .toList()
                                                  .isNotEmpty) {
                                                onLoadingUpdate(
                                                    snapshot.data![0]!["_id"],
                                                    snapshot.data![0]![
                                                            "sl_xuat"] +
                                                        quantity);
                                              } else {
                                                onLoadingAdd();
                                              }
                                            },
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all(
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15)),
                                                shape: MaterialStateProperty.all(
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)))),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary)),
                                            child: const Text(
                                              "Đồng ý",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15)),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1))),
                                      ),
                                      child: const Text("Hủy bỏ"),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        } else if (storage.getItem("existAccount") != null &&
                            storageToken.getItem("token") == null) {
                          showModalBottomSheet<void>(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15)),
                              ),
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  height:
                                      MediaQuery.of(context).size.height * 0.96,
                                  child: const ModalPassExist(),
                                );
                              });
                        } else {
                          showModalBottomSheet<void>(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  height:
                                      MediaQuery.of(context).size.height * 0.96,
                                  child: const ModalPhone(),
                                );
                              });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Thêm vào giỏ hàng",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 15),
                          Image.asset(
                            "assets/images/cart-black.png",
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget pictureProduct(BuildContext context, Map productDetail) {
    return Column(
      children: [
        SizedBox(
            height: 350,
            width: MediaQuery.of(context).size.width - 30,
            child: Stack(
              children: [
                TabBarView(controller: tabController2, children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        // color: checkColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Image.network(
                      "$apiUrl${productDetail["picture"]}?$token",
                      // height: 263,
                      // width: 255,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (productDetail["picture2"] != null)
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          // color: checkColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Image.network(
                        "$apiUrl${productDetail["picture2"]}?$token",
                        // height: 263,
                        // width: 255,
                        fit: BoxFit.contain,
                      ),
                    ),
                  if (productDetail["picture3"] != null)
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          // color: checkColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Image.network(
                        "$apiUrl${productDetail["picture3"]}?$token",
                        // height: 263,
                        // width: 255,
                        fit: BoxFit.contain,
                      ),
                    ),
                  if (productDetail["picture4"] != null)
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          // color: checkColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Image.network(
                        "$apiUrl${productDetail["picture4"]}?$token",
                        // height: 263,
                        // width: 255,
                        fit: BoxFit.cover,
                      ),
                    ),
                ]),
                Positioned(
                    top: 5,
                    right: 15,
                    width: 30,
                    height: 30,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0))),
                      onPressed: () {
                        print("likes");
                      },
                      child: const Icon(
                        Icons.favorite,
                        size: 24,
                        // color: checkTextColor,
                      ),
                    ))
              ],
            )),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 80,
          child: TabBar(
              controller: tabController2,
              // padding: EdgeInsets.zero,
              // indicatorPadding: EdgeInsets.zero,
              onTap: (tabIndex) {
                setState(() {
                  _selectedIndex2 = tabIndex;
                });
              },
              labelColor: Theme.of(context).colorScheme.primary,
              isScrollable: true,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.transparent,
              indicator: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).colorScheme.primary),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: "LexendDeca"),
              tabs: [
                if (productDetail["picture"] != null)
                  SizedBox(
                    width: 50,
                    child: Tab(
                      child: Image.network(
                        "$apiUrl${productDetail["picture"]}?$token",
                        width: 50,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                if (productDetail["picture2"] != null)
                  SizedBox(
                    width: 50,
                    child: Tab(
                      child: Image.network(
                        "$apiUrl${productDetail["picture2"]}?$token",
                        width: 50,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                if (productDetail["picture3"] != null)
                  SizedBox(
                    width: 50,
                    child: Tab(
                      child: Image.network(
                        "$apiUrl${productDetail["picture3"]}?$token",
                        width: 50,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                if (productDetail["picture4"] != null)
                  SizedBox(
                    width: 50,
                    child: Tab(
                      child: Image.network(
                        "$apiUrl${productDetail["picture4"]}?$token",
                        width: 50,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ]),
        ),
      ],
    );
  }

  Widget infomation(String mieu_ta) {
    return Column(
      children: [
        SizedBox(
          child: TabBar(
              controller: tabController,
              // padding: EdgeInsets.zero,
              // indicatorPadding: EdgeInsets.zero,
              onTap: (tabIndex) {
                setState(() {
                  _selectedIndex = tabIndex;
                });
              },
              labelColor: Theme.of(context).colorScheme.primary,
              isScrollable: true,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: "LexendDeca"),
              tabs: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  child: Tab(
                    text: "Chi tiết sản phẩm",
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  child: Tab(text: "Đánh giá sản phẩm"),
                )
              ]),
        ),
        SizedBox(
          height: 250,
          child: TabBarView(controller: tabController, children: [
            ListView(
              children: [
                Html(
                  data: mieu_ta,
                  style: {
                    "p": Style(
                        lineHeight: const LineHeight(1.5),
                        fontSize: FontSize(15),
                        fontWeight: FontWeight.w300)
                  },
                ),
              ],
            ),
            ListView(
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFEFEFEF)))),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/avatar.png"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Lê Mỹ Ngọc"),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "4.0",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Sản phẩm chất lượng, làn da được cải thiện một cách rõ ràng.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text("08:30",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                      fontSize: 12)),
                              Container(
                                width: 1,
                                height: 12,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: Colors.grey,
                              ),
                              Text("23/03/2023",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                      fontSize: 12))
                            ],
                          )
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFEFEFEF)))),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/avatar.png"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Trần Như Quỳnh"),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "5.0",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Chất lượng tốt, giá cả hợp lý. Phù hợp với da khô, sẽ tiếp tục ủng hộ vào lần sau.",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text("12:40",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                      fontSize: 12)),
                              Container(
                                width: 1,
                                height: 12,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: Colors.grey,
                              ),
                              Text("03/04/2023",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                      fontSize: 12))
                            ],
                          )
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFEFEFEF)))),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/avatar.png"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Trần Như Quỳnh"),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "5.0",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Chất lượng tốt, giá cả hợp lý. Phù hợp với da khô, sẽ tiếp tục ủng hộ vào lần sau.",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text("12:40",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                      fontSize: 12)),
                              Container(
                                width: 1,
                                height: 12,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: Colors.grey,
                              ),
                              Text("03/04/2023",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                      fontSize: 12))
                            ],
                          )
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFEFEFEF)))),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/avatar.png"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Trần Như Quỳnh"),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.orange,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "5.0",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Chất lượng tốt, giá cả hợp lý. Phù hợp với da khô, sẽ tiếp tục ủng hộ vào lần sau.",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text("12:40",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                      fontSize: 12)),
                              Container(
                                width: 1,
                                height: 12,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: Colors.grey,
                              ),
                              Text("03/04/2023",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                      fontSize: 12))
                            ],
                          )
                        ]),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ]),
        ),
      ],
    );
  }
}
