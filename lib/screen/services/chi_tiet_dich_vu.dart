import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class ChiTietScreen extends StatefulWidget {
  const ChiTietScreen({super.key});

  @override
  State<ChiTietScreen> createState() => _ChiTietScreenState();
}

String html =
    "<p>Cấy son tươi Hàn Quốc là phương pháp độc quyền tại Hệ thống TMV Ngọc Hường. Công nghệ cấy son tươi Hàn Quốc sử dụng máy phun xăm hiện đại với đầu cấy siêu vi điểm kết hợp với dòng mực tốt nhất thế giới nhẹ nhàng đưa hạt mực vào bên dưới da mà không gây sưng đau như các công nghệ cũ trên thị trường hiện nay. Đảm bảo đôi môi sau bong sẽ căng bóng, mềm mịn, màu lên trong, đẹp.</p><br /><p>Đầu kim sử dụng trong phun xăm siêu nhỏ chỉ lướt nhẹ trên lớp thượng bì không làm chảy máu, không làm tổn thương tế bào môi, đi đến đâu màu bám đến đấy. Làm xong màu môi trong, mỏng mịn và có thể ăn uống, rửa mặt bình thường không phải kiêng cữ bất cứ món gì. Với phương pháp Cấy son tươi Hàn Quốc môi sẽ lên màu tự nhiên, tạo độ căng bóng cho màu môi mỏng, hồng hào nhưng vẫn có độ trẻ trung, đồng thời dáng môi cũng được định hình, viền môi rõ nét hơn.</p></br><p>Tại Ngọc Hường, chúng tôi sử dụng màu mực tốt nhất thế giới với đa dạng bảng màu phù hợp với sở thích của từng</p>";

int choose = 0;
int? _selectedIndex;

class _ChiTietScreenState extends State<ChiTietScreen>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Image.asset(
                      "assets/images/Services/PhunXamMoi/img1.jpg",
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
                        const Text(
                          "Phun xăm môi - Cấy son tươi Hàn Quốc",
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "899.000đ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary),
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
                            children: List.generate(5, (index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      choose = index;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: choose == index
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Colors.black),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40))),
                                        child: choose == index
                                            ? Container(
                                                margin: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                40))),
                                              )
                                            : Container(),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
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
                              const SizedBox(
                                height: 10,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary), //<-- SEE HERE
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.grey), //<-- SEE HERE
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
                                margin: const EdgeInsets.only(top: 10),
                                child: Center(
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 25)),
                                          shape: MaterialStateProperty.all(
                                              const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(30))))),
                                      onPressed: () {},
                                      child: const Text(
                                        "Đánh giá",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              )
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
}
