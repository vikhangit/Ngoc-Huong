import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/booking/booking_step2.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:star_rating/star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class ChiTietScreen extends StatefulWidget {
  final Map detail;
  const ChiTietScreen({super.key, required this.detail});

  @override
  State<ChiTietScreen> createState() => _ChiTietScreenState();
}

int? _selectedIndex;
int? _selectedIndex2;

int starLength = 5;
double _rating = 0;

class _ChiTietScreenState extends State<ChiTietScreen>
    with TickerProviderStateMixin {
  LocalStorage storage = LocalStorage('auth');
  LocalStorage storageToken = LocalStorage('token');
  TabController? tabController;
  TabController? tabController2;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController2 = TabController(
        length: widget.detail["picture4"] != null
            ? 4
            : widget.detail["picture3"] != null
                ? 3
                : widget.detail["picture2"] != null
                    ? 2
                    : 1,
        vsync: this);
    tabController?.addListener(_getActiveTabIndex);
    tabController2?.addListener(_getActiveTabIndex2);
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:9776765434");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  void _getActiveTabIndex2() {
    _selectedIndex2 = tabController2?.index;
  }

  @override
  Widget build(BuildContext context) {
    Map detail = widget.detail;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                    flex: 4,
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
                  flex: 86,
                  child: Center(
                    child: Text(
                      "Chi tiết dịch vụ",
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.only(bottom: 20),
            height: MediaQuery.of(context).size.height * 0.95 -
                145 -
                MediaQuery.of(context).viewInsets.bottom,
            child: ListView(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      "$apiUrl${detail["picture"]}?$token",
                      height: 210,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          detail["ten_vt"],
                          style: const TextStyle(fontSize: 17),
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
                                  NumberFormat.currency(
                                          locale: "vi_VI", symbol: "")
                                      .format(
                                    detail["gia_ban_le"],
                                  ),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  "đ",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.orange,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: const Text("4.8"),
                                ),
                                const Text(
                                  "(130 đánh giá)",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Thông tin dịch vụ",
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: AppBar(
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        primary: false,
                        // bottomOpacity: 0.8,
                        bottom: TabBar(
                            controller: tabController,
                            indicatorPadding: EdgeInsets.zero,
                            onTap: (tabIndex) {
                              setState(() {
                                _selectedIndex = tabIndex;
                              });
                            },
                            labelColor: Theme.of(context).colorScheme.primary,
                            isScrollable: true,
                            unselectedLabelColor: Colors.black,
                            indicatorColor:
                                Theme.of(context).colorScheme.primary,
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "LexendDeca"),
                            tabs: const [
                              Tab(
                                text: "Chi tiết",
                              ),
                              Tab(text: "Bảo hành"),
                              Tab(text: "Đánh giá/Nhận xét"),
                            ]),
                      ),
                    ),
                    Container(
                      height: 280,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Expanded(
                        child: TabBarView(controller: tabController, children: [
                          ListView(
                            children: [
                              Html(
                                data: detail["mieu_ta"],
                                style: {
                                  "*": Style(margin: Margins.only(left: 0)),
                                  "p": Style(
                                      lineHeight: const LineHeight(1.8),
                                      fontSize: FontSize(15),
                                      fontWeight: FontWeight.w300)
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              pictureProduct(context, detail),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          ListView(
                            children: List.generate(5, (index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Bảo hành $index",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          ListView(
                            children: [
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 15, top: 15),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFEFEFEF)))),
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.grey,
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
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
                                      padding: const EdgeInsets.only(
                                          bottom: 15, top: 15),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFEFEFEF)))),
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
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
                                      padding: const EdgeInsets.only(
                                          bottom: 15, top: 15),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFEFEFEF)))),
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
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
                                      padding: const EdgeInsets.only(
                                          bottom: 15, top: 15),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFEFEFEF)))),
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              size: 20,
                                                              color:
                                                                  Colors.orange,
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
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
                            ],
                          )
                        ]),
                      ),
                    ),
                  ],
                )
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
                          onPressed: () {
                            _makingPhoneCall();
                          },
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
                        onPressed: () {
                          if (storage.getItem("existAccount") != null &&
                              storageToken.getItem("token") != null) {
                            showModalBottomSheet<void>(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.0),
                                  ),
                                ),
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .8,
                                      child: ModalDiaChi(
                                        activeService: detail["ten_vt"],
                                      ));
                                });
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
                                    height: MediaQuery.of(context).size.height *
                                        0.96,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.96,
                                    child: const ModalPhone(),
                                  );
                                });
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            const Expanded(
                              flex: 8,
                              child: Center(
                                child: Text(
                                  "Đặt lịch hẹn",
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
                                "assets/images/calendar-black.png",
                                width: 40,
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

  Widget pictureProduct(BuildContext context, Map productDetail) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width - 30,
          child: Expanded(
            child: TabBarView(controller: tabController2, children: [
              Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      // color: checkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Image.network(
                      "$apiUrl${productDetail["picture"]}?$token",
                      width: 220,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )),
              if (productDetail["picture2"] != null)
                Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        // color: checkColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network(
                        "$apiUrl${productDetail["picture2"]}?$token",
                        width: 220,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    )),
              if (productDetail["picture3"] != null)
                Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        // color: checkColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network(
                        "$apiUrl${productDetail["picture3"]}?$token",
                        width: 220,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    )),
              if (productDetail["picture4"] != null)
                Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        // color: checkColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network(
                        "$apiUrl${productDetail["picture4"]}?$token",
                        width: 220,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    )),
            ]),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 70,
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
                    width: 40,
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
                    width: 40,
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
                    width: 40,
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
                    width: 40,
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
}

class ModalDiaChi extends StatefulWidget {
  final String activeService;
  const ModalDiaChi({super.key, required this.activeService});

  @override
  State<ModalDiaChi> createState() => _ModalDiaChiState();
}

Map CN = {};

class _ModalDiaChiState extends State<ModalDiaChi> {
  void chooseDiaChi(Map item) {
    setState(() {
      CN = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    String activeServie = widget.activeService;
    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                height: 50,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Chọn chi nhánh",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          )),
                    )
                  ],
                ),
              ),
              FutureBuilder(
                future: callChiNhanhApi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List list = snapshot.data!.toList();
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .8 - 130,
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                chooseDiaChi(list[index]);
                                // Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 0))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${list[index]["ten_kho"]}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: TextButton(
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all(
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 0)),
                                                shape: MaterialStateProperty.all(
                                                    const ContinuousRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        side: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.blue)))),
                                            onPressed: () {},
                                            child: const Text(
                                              "Xem vị trí",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blue),
                                            )),
                                      )
                                    ],
                                  ),
                                  if (CN["ma_kho"] == list[index]["ma_kho"])
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 20,
                                    )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
          CN.isNotEmpty
              ? Container(
                  height: 50,
                  margin: const EdgeInsets.all(15.0),
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)))),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingStep2(
                                  serviceName: activeServie, activeCN: CN)));
                    },
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Container()),
                        const Expanded(
                          flex: 8,
                          child: Center(
                            child: Text(
                              "Tiếp tục",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            "assets/images/calendar-white.png",
                            width: 20,
                            height: 25,
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 50,
                  margin: const EdgeInsets.all(15.0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.grey[400]!),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      const Expanded(
                        flex: 8,
                        child: Center(
                          child: Text(
                            "Tiếp tục",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          "assets/images/calendar-white.png",
                          width: 20,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
