import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class ProductDetail extends StatefulWidget {
  final Map details;
  final int index;
  final Function(int index) checkColor;
  final Function(int index) checkTextColor;
  const ProductDetail(
      {super.key,
      required this.details,
      required this.index,
      required this.checkColor,
      required this.checkTextColor});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

String html =
    "<p>Cấy son tươi Hàn Quốc là phương pháp độc quyền tại Hệ thống TMV Ngọc Hường. Công nghệ cấy son tươi Hàn Quốc sử dụng máy phun xăm hiện đại với đầu cấy siêu vi điểm kết hợp với dòng mực tốt nhất thế giới nhẹ nhàng đưa hạt mực vào bên dưới da mà không gây sưng đau như các công nghệ cũ trên thị trường hiện nay. Đảm bảo đôi môi sau bong sẽ căng bóng, mềm mịn, màu lên trong, đẹp.</p><br /><p>Đầu kim sử dụng trong phun xăm siêu nhỏ chỉ lướt nhẹ trên lớp thượng bì không làm chảy máu, không làm tổn thương tế bào môi, đi đến đâu màu bám đến đấy. Làm xong màu môi trong, mỏng mịn và có thể ăn uống, rửa mặt bình thường không phải kiêng cữ bất cứ món gì. Với phương pháp Cấy son tươi Hàn Quốc môi sẽ lên màu tự nhiên, tạo độ căng bóng cho màu môi mỏng, hồng hào nhưng vẫn có độ trẻ trung, đồng thời dáng môi cũng được định hình, viền môi rõ nét hơn.</p></br><p>Tại Ngọc Hường, chúng tôi sử dụng màu mực tốt nhất thế giới với đa dạng bảng màu phù hợp với sở thích của từng</p>";

int choose = 0;
int? _selectedIndex;
int? _selectedIndex2;
int quantity = 1;

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  TabController? tabController;
  TabController? tabController2;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
    tabController2 = TabController(length: 4, vsync: this);
    tabController2?.addListener(_getActiveTabIndex2);
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  void _getActiveTabIndex2() {
    _selectedIndex2 = tabController2?.index;
  }

  @override
  Widget build(BuildContext context) {
    Map productDetail = widget.details;
    int index = widget.index;
    Color checkColor = widget.checkColor(index);
    Color checkTextColor = widget.checkTextColor(index);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    flex: 8,
                    child: SizedBox(
                      height: 20,
                      child: TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.west,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    )),
                const Expanded(
                  flex: 84,
                  child: Center(
                    child: Text(
                      "Chi tiết sản phẩm",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            margin: const EdgeInsets.only(bottom: 20),
            height: MediaQuery.of(context).size.height * 0.95 -
                145 -
                MediaQuery.of(context).viewInsets.bottom,
            child: ListView(
              children: [
                pictureProduct(
                    context, productDetail, checkColor, checkTextColor),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "${productDetail["title"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Wrap(
                        children: const [
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
                      Text(
                        "${productDetail["price"]} đ",
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary),
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
                infomation(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                    flex: 23,
                    child: Container(
                      decoration: BoxDecoration(
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
                      child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                vertical: 15,
                              )),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {},
                          child: Image.asset(
                            "assets/images/call-black.png",
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          )),
                    )),
                Expanded(flex: 2, child: Container()),
                Expanded(
                    flex: 75,
                    child: TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)))),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.4))),
                        onPressed: () {},
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            const Expanded(
                              flex: 8,
                              child: Center(
                                child: Text(
                                  "Mua ngay",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/cart-black.png",
                                width: 35,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        )))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget pictureProduct(BuildContext context, Map productDetail,
      Color checkColor, Color checkTextColor) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          width: MediaQuery.of(context).size.width - 30,
          child: Expanded(
              child: Stack(
            children: [
              TabBarView(controller: tabController2, children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: checkColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Image.asset(
                    productDetail["img"],
                    height: 263,
                    width: 255,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: checkColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Image.asset(
                    "assets/images/Services/MyPham/DeXuat/img1-2.png",
                    height: 263,
                    width: 255,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: checkColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Image.asset(
                    "assets/images/Services/MyPham/DeXuat/img1-3.png",
                    height: 263,
                    width: 255,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: checkColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Image.asset(
                    "assets/images/Services/MyPham/DeXuat/img1-4.png",
                    height: 263,
                    width: 255,
                    fit: BoxFit.contain,
                  ),
                ),
              ]),
              Positioned(
                  top: 10,
                  right: 10,
                  width: 30,
                  height: 30,
                  child: TextButton(
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(0))),
                    onPressed: () {
                      print("likes");
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 24,
                      color: checkTextColor,
                    ),
                  ))
            ],
          )),
        ),
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
                SizedBox(
                  width: 50,
                  child: Tab(
                    child: Image.asset(
                      "assets/images/Services/MyPham/DeXuat/img1.png",
                      width: 50,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Tab(
                    child: Image.asset(
                      "assets/images/Services/MyPham/DeXuat/img1-2.png",
                      width: 50,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Tab(
                    child: Image.asset(
                      "assets/images/Services/MyPham/DeXuat/img1-3.png",
                      width: 50,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Tab(
                    child: Image.asset(
                      "assets/images/Services/MyPham/DeXuat/img1-4.png",
                      width: 50,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ]),
        ),
      ],
    );
  }

  Widget infomation() {
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
          child: Expanded(
            child: TabBarView(controller: tabController, children: [
              ListView(
                children: [
                  Html(
                    data: html,
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
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          "https://s3-alpha-sig.figma.com/img/05ee/48aa/de7b6e9524212508334e50ea61c70030?Expires=1685923200&Signature=ao8Y5LFoFE~nLjPHgdUHlhowtDPdz92-yq5N5OVPwf3vhuoEKepX2AUuU8WvzmSYWHt7VS935gkLD9OtybrDHJu~dIcw9pKO8-2w2wK5bfTppajCBK6WLv8Byxi6ItQ~ygH9~Ao-vioBbO~rbFG61WnWQB9ICdQfvsFGInnJ65Yasu3ISdhueofoEfe0AwzLPinT9WlGVuDrQqXt2saUq~sEKJaEh~04TwHVe2h0k3xxzqmNalefsUOJfsF4wgRLjneuhw4ohxaTwSrZVrTqzgIebeuAaV1IHWjmWNIqQ8MQcs350QGwUTc9F1uz0yX4D2Jt379dXKQGLPjPY-~fjQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Lê Mỹ Ngọc"),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: const [
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
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Sản phẩm chất lượng, làn da được cải thiện một cách rõ ràng.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
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
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          "https://s3-alpha-sig.figma.com/img/d218/110b/54375111eb4647c0f179786ae58e442c?Expires=1685923200&Signature=b-WOUS2n7mWd72rx~qHmrPoczkeGuh1s6Qu6DDn8z2eG7PYDCNwlODJ7vTWJV9HfkGTapAH0abLUVoKb47NLTVag9c~~GyTBpNh2SEeutIYdogDzYL4y7Z-Zol~CNzNpR43W6OMhkEZObj9acXFk7yMrCGaldc6pyln~u37~oOa1oLAeemXhp8ZIicQa3LzyGet22qjx07LuVlJ1HFVuvBUb9nGaBI27ipUnJnJNoXG3VJfBulFOKdeGdS2DSjaxCKvEQ0MD50CcAGlCECY64rRLynVnWYW~z3CGqjtYrlBWDFiSAHo2TzwZvnepufo5bxl4t4cvZ6~gWys6YHuRCQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Trần Như Quỳnh"),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: const [
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
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Chất lượng tốt, giá cả hợp lý. Phù hợp với da khô, sẽ tiếp tục ủng hộ vào lần sau.",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
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
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          "https://s3-alpha-sig.figma.com/img/d218/110b/54375111eb4647c0f179786ae58e442c?Expires=1685923200&Signature=b-WOUS2n7mWd72rx~qHmrPoczkeGuh1s6Qu6DDn8z2eG7PYDCNwlODJ7vTWJV9HfkGTapAH0abLUVoKb47NLTVag9c~~GyTBpNh2SEeutIYdogDzYL4y7Z-Zol~CNzNpR43W6OMhkEZObj9acXFk7yMrCGaldc6pyln~u37~oOa1oLAeemXhp8ZIicQa3LzyGet22qjx07LuVlJ1HFVuvBUb9nGaBI27ipUnJnJNoXG3VJfBulFOKdeGdS2DSjaxCKvEQ0MD50CcAGlCECY64rRLynVnWYW~z3CGqjtYrlBWDFiSAHo2TzwZvnepufo5bxl4t4cvZ6~gWys6YHuRCQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Trần Như Quỳnh"),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: const [
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
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Chất lượng tốt, giá cả hợp lý. Phù hợp với da khô, sẽ tiếp tục ủng hộ vào lần sau.",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
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
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          "https://s3-alpha-sig.figma.com/img/d218/110b/54375111eb4647c0f179786ae58e442c?Expires=1685923200&Signature=b-WOUS2n7mWd72rx~qHmrPoczkeGuh1s6Qu6DDn8z2eG7PYDCNwlODJ7vTWJV9HfkGTapAH0abLUVoKb47NLTVag9c~~GyTBpNh2SEeutIYdogDzYL4y7Z-Zol~CNzNpR43W6OMhkEZObj9acXFk7yMrCGaldc6pyln~u37~oOa1oLAeemXhp8ZIicQa3LzyGet22qjx07LuVlJ1HFVuvBUb9nGaBI27ipUnJnJNoXG3VJfBulFOKdeGdS2DSjaxCKvEQ0MD50CcAGlCECY64rRLynVnWYW~z3CGqjtYrlBWDFiSAHo2TzwZvnepufo5bxl4t4cvZ6~gWys6YHuRCQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Trần Như Quỳnh"),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: const [
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
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Chất lượng tốt, giá cả hợp lý. Phù hợp với da khô, sẽ tiếp tục ủng hộ vào lần sau.",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
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
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: const Text(
                      "Đánh giá",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: const [
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
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "4.0",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    maxLines: 4,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .primary), //<-- SEE HERE
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 1, color: Colors.grey), //<-- SEE HERE
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18),
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.3),
                          fontWeight: FontWeight.w400),
                      hintText: 'Nhập đánh giá',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 25)),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))))),
                          onPressed: () {},
                          child: const Text(
                            "Xác nhận",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            ]),
          ),
        ),
      ],
    );
  }
}
