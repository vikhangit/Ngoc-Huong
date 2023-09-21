
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/cart/cart_success.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';

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
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final LocalStorage localStorageCustomerCart = LocalStorage("customer_cart");
  final CartModel cartModel = CartModel();
  final CustomModal customModal = CustomModal();

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
    tabController2 = TabController(length: 2, vsync: this);
    tabController2?.addListener(_getActiveTabIndex2);
  }

  @override
  void dispose() {
    quantity = 1;
    super.dispose();
  }

  void save() {
    setState(() {});
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  void _getActiveTabIndex2() {
    _selectedIndex2 = tabController2?.index;
  }

  @override
  Widget build(BuildContext context) {
    print("Quantity: ${quantity}");
    Map productDetail = widget.details;
    void addToCart() async {
      customModal.showAlertDialog(context, "error", "Giỏ hàng",
          "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
        Navigator.pop(context);
        EasyLoading.show(status: "Vui lòng chờ...");
        Future.delayed(const Duration(seconds: 2), () {
          cartModel.addProductToCart(
              {...productDetail, "quantity": quantity}).then((value) {
            EasyLoading.dismiss();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCartSuccess()));
          });
        });
      }, () => Navigator.pop(context));
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
                  child: GestureDetector(
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
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      // color: checkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Image.network(
                    "http://api_ngochuong.osales.vn/assets/css/images/noimage.gif",

                    // height: 263,
                    // width: 255,
                    fit: BoxFit.contain,
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "${productDetail["Name"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            NumberFormat.currency(locale: "vi_VI", symbol: "")
                                .format(
                              productDetail["PriceOutbound"],
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
                          GestureDetector(
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
                          GestureDetector(
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
                infomation(productDetail["Description"] ?? ""),
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
                        if (storageCustomerToken.getItem("customer_token") !=
                            null) {
                          addToCart();
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
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

  // Widget pictureProduct(BuildContext context, Map productDetail) {
  //   return Column(
  //     children: [
  //       SizedBox(
  //           height: 350,
  //           width: MediaQuery.of(context).size.width - 30,
  //           child: Stack(
  //             children: [
  //               TabBarView(controller: tabController2, children: [
  //                 Container(
  //                   alignment: Alignment.center,
  //                   decoration: const BoxDecoration(
  //                       // color: checkColor,
  //                       borderRadius: BorderRadius.all(Radius.circular(10))),
  //                   child: Image.network(
  //                     "$apiUrl${productDetail["picture"]}?$token",
  //                     // height: 263,
  //                     // width: 255,
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ),
  //                 if (productDetail["picture2"] != null)
  //                   Container(
  //                     alignment: Alignment.center,
  //                     decoration: const BoxDecoration(
  //                         // color: checkColor,
  //                         borderRadius: BorderRadius.all(Radius.circular(10))),
  //                     child: Image.network(
  //                       "$apiUrl${productDetail["picture2"]}?$token",
  //                       // height: 263,
  //                       // width: 255,
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                 if (productDetail["picture3"] != null)
  //                   Container(
  //                     alignment: Alignment.center,
  //                     decoration: const BoxDecoration(
  //                         // color: checkColor,
  //                         borderRadius: BorderRadius.all(Radius.circular(10))),
  //                     child: Image.network(
  //                       "$apiUrl${productDetail["picture3"]}?$token",
  //                       // height: 263,
  //                       // width: 255,
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                 if (productDetail["picture4"] != null)
  //                   Container(
  //                     alignment: Alignment.center,
  //                     decoration: const BoxDecoration(
  //                         // color: checkColor,
  //                         borderRadius: BorderRadius.all(Radius.circular(10))),
  //                     child: Image.network(
  //                       "$apiUrl${productDetail["picture4"]}?$token",
  //                       // height: 263,
  //                       // width: 255,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //               ]),
  //               Positioned(
  //                   top: 5,
  //                   right: 15,
  //                   width: 30,
  //                   height: 30,
  //                   child: TextButton(
  //                     style: ButtonStyle(
  //                         padding: MaterialStateProperty.all(
  //                             const EdgeInsets.all(0))),
  //                     onPressed: () {
  //                       print("likes");
  //                     },
  //                     child: const Icon(
  //                       Icons.favorite,
  //                       size: 24,
  //                       // color: checkTextColor,
  //                     ),
  //                   ))
  //             ],
  //           )),
  //       const SizedBox(
  //         height: 30,
  //       ),
  //       SizedBox(
  //         height: 80,
  //         child: TabBar(
  //             controller: tabController2,
  //             // padding: EdgeInsets.zero,
  //             // indicatorPadding: EdgeInsets.zero,
  //             onTap: (tabIndex) {
  //               setState(() {
  //                 _selectedIndex2 = tabIndex;
  //               });
  //             },
  //             labelColor: Theme.of(context).colorScheme.primary,
  //             isScrollable: true,
  //             unselectedLabelColor: Colors.black,
  //             indicatorColor: Colors.transparent,
  //             indicator: BoxDecoration(
  //                 border: Border.all(
  //                     width: 1, color: Theme.of(context).colorScheme.primary),
  //                 borderRadius: const BorderRadius.all(Radius.circular(10))),
  //             labelStyle: const TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 14,
  //                 fontFamily: "LexendDeca"),
  //             tabs: [
  //               if (productDetail["picture"] != null)
  //                 SizedBox(
  //                   width: 50,
  //                   child: Tab(
  //                     child: Image.network(
  //                       "$apiUrl${productDetail["picture"]}?$token",
  //                       width: 50,
  //                       height: 60,
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                 ),
  //               if (productDetail["picture2"] != null)
  //                 SizedBox(
  //                   width: 50,
  //                   child: Tab(
  //                     child: Image.network(
  //                       "$apiUrl${productDetail["picture2"]}?$token",
  //                       width: 50,
  //                       height: 60,
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                 ),
  //               if (productDetail["picture3"] != null)
  //                 SizedBox(
  //                   width: 50,
  //                   child: Tab(
  //                     child: Image.network(
  //                       "$apiUrl${productDetail["picture3"]}?$token",
  //                       width: 50,
  //                       height: 60,
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                 ),
  //               if (productDetail["picture4"] != null)
  //                 SizedBox(
  //                   width: 50,
  //                   child: Tab(
  //                     child: Image.network(
  //                       "$apiUrl${productDetail["picture4"]}?$token",
  //                       width: 50,
  //                       height: 60,
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                 ),
  //             ]),
  //       ),
  //     ],
  //   );
  // }

  Widget infomation(String mieuTa) {
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
                  child: const Tab(
                    text: "Chi tiết sản phẩm",
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  child: const Tab(text: "Đánh giá sản phẩm"),
                )
              ]),
        ),
        SizedBox(
          height: 250,
          child: TabBarView(controller: tabController, children: [
            ListView(
              children: [
                Html(
                  data: mieuTa,
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
                              GestureDetector(
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
                              GestureDetector(
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
                              GestureDetector(
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
                              GestureDetector(
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
