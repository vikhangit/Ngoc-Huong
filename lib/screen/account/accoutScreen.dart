import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

List menu = [
  {
    "icon": Icons.person_pin,
    "title": "Thông tin tài khoản",
  },
  {
    "icon": Icons.speaker_notes_outlined,
    "title": "Lịch sử giao dịch",
  },
  {
    "icon": Icons.backup_table_outlined,
    "title": "Lịch sử đặt bàn",
  },
  {
    "icon": Icons.note_alt_outlined,
    "title": "Điều khoản sử dụng",
  },
  {
    "icon": Icons.people_outline,
    "title": "Giới thiệu bạn bè",
  },
  {
    "icon": Icons.location_on_outlined,
    "title": "Quản lý địa chỉ",
  },
  {
    "icon": Icons.settings_outlined,
    "title": "Cài đặt",
  },
  {
    "icon": Icons.info_outline,
    "title": "Về Ngọc Hường",
  }
];

class _AccountScreenState extends State<AccountScreen> {
  final LocalStorage storage = LocalStorage("auth");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: const MyBottomMenu(
            active: 3,
          ),
          drawer: const MyLeftMenu(),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 25),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/call-black.png",
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("Hỗ trợ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400))
                            ],
                          )),
                    ),
                    Expanded(
                        child: Center(
                            child: Stack(children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xff00A3FF),
                        backgroundImage: AssetImage("assets/images/avatar.png"),
                        radius: 35.0,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                // border: Border.all(width: 2, color: Colors.white),
                                borderRadius: BorderRadius.circular(90.0),
                                color: Colors.blue[100]),
                            child: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.linked_camera,
                                  size: 16,
                                  color: Colors.blue[600],
                                ))),
                      )
                    ]))),
                    Expanded(
                        child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 55,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4)),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.yellow[300],
                                size: 28,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text(
                                "0",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: const [
                  Text("Tran Khang",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
                  Text("Mã KH: 032131321",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 47,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Image.network(
                                "https://cdn-icons-png.flaticon.com/512/2385/2385865.png",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Silver",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text("Nâng hạng",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300))
                              ],
                            )
                          ],
                        ),
                      )),
                  Expanded(flex: 6, child: Container()),
                  Expanded(
                      flex: 47,
                      child: Container(
                        margin: const EdgeInsets.only(right: 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Image.network(
                                "https://cdn-icons-png.flaticon.com/512/3702/3702999.png",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Ưu đãi",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text("Dùng ngay",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300))
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(top: 20),
                height: 450,
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      decoration: const BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.linked_camera,
                                color: Colors.amber[200],
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "G-BUSINESS",
                                style: TextStyle(color: Colors.amber[200]),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Text(
                                "Tài khoản tiếp khách dành cho doanh nghiệp",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.amber[200]),
                              )),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.amber[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    "Chi tiết",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: menu.map((element) {
                        int index = menu.indexOf(element);
                        return SizedBox(
                          height: 60,
                          child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 15))),
                              onPressed: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Icon(
                                          element["icon"],
                                          color: Colors.black,
                                          size: 26,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                85,
                                        child: Text(
                                          "${element["title"]}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ),
                                  if (index < menu.length - 1)
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 55, top: 5),
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      color: Colors.grey.withOpacity(0.2),
                                      height: 1,
                                    )
                                ],
                              )),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ))
            ],
          )),
    );
  }
}
