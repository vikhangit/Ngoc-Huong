import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/cart/cart_success.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
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
int activeTab = 1;

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
      activeTab= 1;
    });
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
    tabController2 = TabController(length: 2, vsync: this);
    tabController2?.addListener(_getActiveTabIndex2);
  }

  @override
  void dispose() {
    quantity = 1;
    activeTab= 1;
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
    Map productDetail = widget.details;
    void addToCart() async {
      customModal.showAlertDialog(context, "error", "Giỏ hàng",
          "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
        Navigator.pop(context);
        EasyLoading.show(status: "Vui lòng chờ...");
        Future.delayed(const Duration(seconds: 2), () {
          Map data = {
            "DetailList": [
              {
                "Amount": productDetail["PriceInbound"] * quantity,
                "Price": productDetail["PriceInbound"],
                "PrinceTest": productDetail["PriceInbound"] * quantity,
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
      }, () => Navigator.pop(context));
    }
    void updateCart(Map item) async {
      customModal.showAlertDialog(context, "error", "Giỏ hàng",
          "Bạn có chắc chắn thêm sản phẩm vào giỏ hàng?", () {
            Navigator.pop(context);
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
              }).then((value){
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: const EdgeInsets.only(bottom: 5),
            height: MediaQuery.of(context).size.height * 0.85 -
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
                    "${productDetail["Image_Name"]}",
                    // height: 150,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
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
                              productDetail["PriceInbound"],
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
                infomation(productDetail["Description"] ?? "",
                    (index) => goToTab(index), activeTab),
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
                  child: FutureBuilder(future: cartModel.getDetailCartByCode(productDetail["Code"].toString()),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return TextButton(
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
                                  if(snapshot.data!.isNotEmpty){
                                    updateCart(snapshot.data!);
                                  }else{
                                    addToCart();
                                  }
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
                              ));
                        }else{
                          return const Center(
                            child:  SizedBox(
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
          )
        ],
      ),
    );
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
                          MaterialStateProperty.all(const EdgeInsets.all(0))),
                  onPressed: () => goToTab(1),
                  child: Text("Chi tiết sản phẩm", style: TextStyle(
                    color: activeTab == 1 ? Theme.of(context).colorScheme.primary : Colors.black
                  ),),
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
                          MaterialStateProperty.all(const EdgeInsets.all(0))),
                  onPressed: () => goToTab(2),
                  child: Text("Đánh giả sản phẩm", style: TextStyle(
                      color: activeTab == 2 ? Theme.of(context).colorScheme.primary : Colors.black
                  )),
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
              ? Html(
                  data: mieuTa,
                  style: {
                    "p": Style(
                        lineHeight: const LineHeight(1.5),
                        fontSize: FontSize(15),
                        fontWeight: FontWeight.w300)
                  },
                )
              : SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(5, (index){
                      return Container(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xFFEFEFEF)))),
                        child: Column(children: [
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
                              Text("Lê Mỹ Ngọc"),
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
                      );
                    })
                  ),
                ),
        ),
      ],
    );
  }
}
