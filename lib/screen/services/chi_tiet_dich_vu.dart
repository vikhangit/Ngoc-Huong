import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/utils/callapi.dart';

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
  LocalStorage storageCN = LocalStorage("chi_nhanh");
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

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  void _getActiveTabIndex2() {
    _selectedIndex2 = tabController2?.index;
  }

  @override
  Widget build(BuildContext context) {
    Map detail = widget.detail;
    Map chiNhanh = jsonDecode(storageCN.getItem("chi_nhanh"));
    return Container(
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
                      "Chi tiết dịch vụ",
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            // margin: const EdgeInsets.only(bottom: 10),
            height: MediaQuery.of(context).size.height * 0.95 -
                192 -
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
                      height: 255,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
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
                                                  fontWeight: FontWeight.w300),
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
                                            margin: const EdgeInsets.symmetric(
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
                                                  fontWeight: FontWeight.w300),
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
                                            margin: const EdgeInsets.symmetric(
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
                                                  fontWeight: FontWeight.w300),
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
                                            margin: const EdgeInsets.symmetric(
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
                                                  fontWeight: FontWeight.w300),
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
                                            margin: const EdgeInsets.symmetric(
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
                  ],
                )
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
                          // showModalBottomSheet<void>(
                          //     clipBehavior: Clip.antiAliasWithSaveLayer,
                          //     context: context,
                          //     shape: const RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.vertical(
                          //         top: Radius.circular(15.0),
                          //       ),
                          //     ),
                          //     isScrollControlled: true,
                          //     builder: (BuildContext context) {
                          //       return Container(
                          //           padding: EdgeInsets.only(
                          //               bottom: MediaQuery.of(context)
                          //                   .viewInsets
                          //                   .bottom),
                          //           height:
                          //               MediaQuery.of(context).size.height * .8,
                          //           child: ModalDiaChiBooking(
                          //             activeService: detail["ten_vt"],
                          //           ));
                          //     });
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
                        }
                        // else {
                        //   showModalBottomSheet<void>(
                        //       clipBehavior: Clip.antiAliasWithSaveLayer,
                        //       context: context,
                        //       isScrollControlled: true,
                        //       builder: (BuildContext context) {
                        //         return Container(
                        //           padding: EdgeInsets.only(
                        //               bottom: MediaQuery.of(context)
                        //                   .viewInsets
                        //                   .bottom),
                        //           height:
                        //               MediaQuery.of(context).size.height * 0.96,
                        //           child: const ModalPhone(),
                        //         );
                        //       });
                        // }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Đặt lịch hẹn",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 15),
                          Image.asset(
                            "assets/images/calendar-black.png",
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ],
                      )),
                )
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
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Image.network(
                      "$apiUrl${productDetail["picture4"]}?$token",
                      width: 220,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )),
          ]),
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
