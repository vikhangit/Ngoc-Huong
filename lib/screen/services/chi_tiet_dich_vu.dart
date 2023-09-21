
import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';

class ChiTietScreen extends StatefulWidget {
  final Map detail;
  const ChiTietScreen({super.key, required this.detail});

  @override
  State<ChiTietScreen> createState() => _ChiTietScreenState();
}

int? _selectedIndex;

int starLength = 5;
double _rating = 0;

class _ChiTietScreenState extends State<ChiTietScreen>
    with TickerProviderStateMixin {
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  void save() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map detail = widget.detail;
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
                      "${detail["Image_Name"]}",
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
                          detail["Name"],
                          style: const TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              NumberFormat.currency(
                                  locale: "vi_VI", symbol: "")
                                  .format(
                                detail["PriceOutbound"],
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
                        const SizedBox(
                          height: 15,
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
                            tabs: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: const Tab(
                                  text: "Chi tiết",
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child:Tab(text: "Đánh giá/Nhận xét"),
                              )
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
                              data: detail["Description"] ?? "",
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
                          ],
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
                                          GestureDetector(
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
                                          GestureDetector(
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
                                          GestureDetector(
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
                                          GestureDetector(
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
                        if (storageCustomerToken.getItem("customer_token") ==
                            null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingServices(
                                        dichvudachon: detail,
                                      )));
                        }
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
}
