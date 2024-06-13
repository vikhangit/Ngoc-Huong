import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/screen/cart/cart_success.dart';
import 'package:ngoc_huong/screen/modalZoomImage.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:upgrader/upgrader.dart';

class GiftShopDetail extends StatefulWidget {
  final Map details;
  final String type;
  const GiftShopDetail({super.key, required this.details, required this.type});

  @override
  State<GiftShopDetail> createState() => _GiftShopDetailState();
}

List cartItem = [];
int choose = 0;
int? _selectedIndex;
int? _selectedIndex2;
int quantity = 1;
int starLength = 5;
double _rating = 0;
int activeTab = 1;

class _GiftShopDetailState extends State<GiftShopDetail>
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
    Upgrader.clearSavedSettings();
    setState(() {
      quantity = 1;
      activeTab = 1;
    });
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
    tabController2 = TabController(length: 2, vsync: this);
    tabController2?.addListener(_getActiveTabIndex2);
  }

  @override
  void dispose() {
    quantity = 1;
    activeTab = 1;
    super.dispose();
  }

  void save() {
    setState(() {});
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  void goToTab(int index) {
    setState(() {
      activeTab = index;
    });
  }

  void _getActiveTabIndex2() {
    _selectedIndex2 = tabController2?.index;
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    Map productDetail = widget.details;
    void addToCart() async {
      customModal.showAlertDialog(context, "error", "Giỏ hàng",
          "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
        Navigator.of(context).pop();
        EasyLoading.show(status: "Vui lòng chờ...");
        Future.delayed(const Duration(seconds: 2), () {
          Map data = {
            "DetailList": [
              {
                "Amount": productDetail["PriceOutbound"] * quantity,
                "Price": productDetail["PriceOutbound"],
                "PrinceTest": productDetail["PriceOutbound"] * quantity,
                "ProductCode": productDetail["Code"],
                "ProductId": productDetail["Id"],
                "Quantity": quantity,
              }
            ]
          };
          cartModel.addToCart(data).then((value) {
            EasyLoading.dismiss();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCartSuccess()));
          });
        });
      }, () => Navigator.of(context).pop());
    }

    void updateCart(Map item) async {
      customModal.showAlertDialog(context, "error", "Giỏ hàng",
          "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
        Navigator.of(context).pop();
        EasyLoading.show(status: "Vui lòng chờ...");
        Future.delayed(const Duration(seconds: 2), () {
          cartModel.updateProductInCart({
            // "Id": 1,
            "DetailList": [
              {
                ...item,
                "Ammount": item["Quantity"] + quantity * item["Price"],
                "Quantity": item["Quantity"] + quantity
              }
            ]
          }).then((value) {
            EasyLoading.dismiss();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCartSuccess()));
          });
        });
      }, () => Navigator.of(context).pop());
    }

    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
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
              title: const Text("Chi tiết ưu đãi",
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImageDetail(
                                    item: productDetail,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "${productDetail["Name"]}",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/icon/Xu1.png",
                                            width: 25,
                                            height: 25,
                                          ),
                                          const SizedBox(width: 3),
                                          const Text(
                                            "10.000",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Image.asset(
                                      //       "assets/images/calendar-solid-black.png",
                                      //       width: 24,
                                      //       height: 24,
                                      //       fit: BoxFit.contain,
                                      //     ),
                                      //     const SizedBox(width: 3),
                                      //     const Text(
                                      //       "Còn 100",
                                      //       style: TextStyle(
                                      //           fontWeight: FontWeight.w600,
                                      //           color: Colors.black),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // infomation()
                                ]),
                            infomation(productDetail["Description"] ?? "",
                                (index) => goToTab(index), activeTab),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        color: Colors.white,
                        child: FutureBuilder(
                          future: cartModel.getDetailCartByCode(
                              productDetail["Code"].toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return TextButton(
                                  style: ButtonStyle(
                                      padding: WidgetStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 20)),
                                      shape: WidgetStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)))),
                                      backgroundColor: WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.4))),
                                  onPressed: () {
                                    // if (storageCustomerToken
                                    //         .getItem("customer_token") !=
                                    //     null) {
                                    //   if (snapshot.data!.isNotEmpty) {
                                    //     updateCart(snapshot.data!);
                                    //   } else {
                                    //     addToCart();
                                    //   }
                                    // } else {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               const LoginScreen()));
                                    // }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Dùng xu để đổi",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(width: 5),
                                      Image.asset(
                                        "assets/images/icon/Xu1.png",
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ));
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
                      ),
                    ],
                  ),
                ))));
  }

  Widget infomation(String mieuTa, Function(int index) goToTab, int activeTab) {
    return Column(
      children: [
        SizedBox(
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
                                color: Theme.of(context).colorScheme.primary)
                            : BorderSide.none)),
                child: TextButton(
                  style: ButtonStyle(
                      padding:
                          WidgetStateProperty.all(const EdgeInsets.all(0))),
                  onPressed: () => goToTab(1),
                  child: Text(
                    "Chi tiết sản phẩm",
                    style: TextStyle(
                        color: activeTab == 1
                            ? Theme.of(context).colorScheme.primary
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
                                color: Theme.of(context).colorScheme.primary)
                            : BorderSide.none)),
                child: TextButton(
                  style: ButtonStyle(
                      padding:
                          WidgetStateProperty.all(const EdgeInsets.all(0))),
                  onPressed: () => goToTab(2),
                  child: Text("Đánh giá sản phẩm",
                      style: TextStyle(
                          color: activeTab == 2
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black)),
                ),
              ))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          child: activeTab == 1
              ? HtmlWidget(
                  mieuTa,
                  // style: {
                  //   "*": Style(
                  //       margin: Margins.only(left: 0),
                  //       textAlign: TextAlign.justify),
                  //   "p": Style(
                  //       lineHeight: const LineHeight(1.8),
                  //       fontSize: FontSize(15),
                  //       fontWeight: FontWeight.w300,
                  //       textAlign: TextAlign.justify),
                  //   "img": Style(margin: Margins.only(top: 5))
                  // },
                )
              : SizedBox(
                  child: Text(
                    "Chúng tôi đang nâng cấp tính năng này",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),

                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: List.generate(5, (index){
                  //     return Container(
                  //       padding: const EdgeInsets.only(bottom: 15, top: 15),
                  //       decoration: const BoxDecoration(
                  //           border: Border(
                  //               bottom: BorderSide(
                  //                   width: 1, color: Color(0xFFEFEFEF)))),
                  //       child: Column(children: [
                  //         const Row(
                  //           children: [
                  //             SizedBox(
                  //               width: 36,
                  //               height: 36,
                  //               child: CircleAvatar(
                  //                 backgroundImage: AssetImage(
                  //                     "assets/images/avatar.png"),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               width: 8,
                  //             ),
                  //             Text("Lê Mỹ Ngọc"),
                  //           ],
                  //         ),
                  //         const SizedBox(
                  //           height: 10,
                  //         ),
                  //         const Row(
                  //           children: [
                  //             Expanded(
                  //               child: Text(
                  //                 "Sản phẩm chất lượng, làn da được cải thiện một cách rõ ràng.",
                  //                 textAlign: TextAlign.left,
                  //                 style: TextStyle(fontWeight: FontWeight.w300),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         const SizedBox(
                  //           height: 5,
                  //         ),
                  //         Row(
                  //           children: [
                  //             Text("08:30",
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.w400,
                  //                     color: Colors.grey[500],
                  //                     fontSize: 12)),
                  //             Container(
                  //               width: 1,
                  //               height: 12,
                  //               margin:
                  //               const EdgeInsets.symmetric(horizontal: 5),
                  //               color: Colors.grey,
                  //             ),
                  //             Text("23/03/2023",
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.w400,
                  //                     color: Colors.grey[500],
                  //                     fontSize: 12))
                  //           ],
                  //         )
                  //       ]),
                  //     );
                  //   })
                  // ),
                ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
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
  PageController pageController = PageController();
  CustomModal customModal = CustomModal();
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
    List newList = widget.item["ImageList"].isNotEmpty
        ? [
            widget.item["ImageList"][0]["Image_Name"],
            widget.item["ImageList"][0]["Image_Name2"],
            widget.item["ImageList"][0]["Image_Name3"],
            widget.item["ImageList"][0]["Image_Name4"],
            widget.item["ImageList"][0]["Image_Name5"]
          ]
        : [widget.item["Image_Name"]];
    List<String> result = <String>[];
    for (var x in newList) {
      if (!["", null, false, 0].contains(x)) {
        result.add(x);
      }
    }

    List<Widget> imgList = List<Widget>.generate(
      result.length,
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
                SizedBox(
                  height: 80,
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
                              width: 80,
                              height: 80,
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
                      fit: BoxFit.cover,
                    ),
                  ))
              : Container(
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
                                      imageList: [
                                        "${widget.item["Image_Name"]}"
                                      ])));
                    },
                    child: Image.network(
                      "${widget.item["Image_Name"]}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, exception, stackTrace) {
                        return Image.network(
                            fit: BoxFit.cover,
                            'http://ngochuong.osales.vn/assets/css/images/noimage.gif');
                      },
                    ),
                  )),
    );
  }
}
