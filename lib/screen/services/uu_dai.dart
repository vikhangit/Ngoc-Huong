import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/modal/modal_chi_nhanh.dart';

class UuDaiScreen extends StatefulWidget {
  const UuDaiScreen({super.key});

  @override
  State<UuDaiScreen> createState() => _UuDaiScreenState();
}

List uudaidatbiet = [
  {
    "img": "assets/images/Services/UuDai/DatBiet/img1.png",
    "title": "Valentine nhân 2 ưu đãi - Làm đẹp giảm đến 75%",
    "date": "01/02/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DatBiet/img2.jpg",
    "title": "Tân trang nhan sắc - Vui đón xuân sang",
    "date": "12/01/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DatBiet/img1.png",
    "title": "Valentine nhân 2 ưu đãi - Làm đẹp giảm đến 75%",
    "date": "01/02/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DatBiet/img2.jpg",
    "title": "Tân trang nhan sắc - Vui đón xuân sang",
    "date": "01/02/2023"
  },
];

List uudaidanhchoban = [
  {
    "img": "assets/images/Services/UuDai/DanhChoBan/img1.png",
    "title": "Đi càng đông ưu đãi càng nhiều chỉ có tại TMV",
    "date": "20/02/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DanhChoBan/img2.png",
    "title": "Tháng 3 làm đẹp thả ga - Đi 2 tính tiền 1",
    "date": "04/03/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DanhChoBan/img3.png",
    "title": "Trao nhan sắc - Gửi yêu thương siêu ưu đãi",
    "date": "12/02/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DanhChoBan/img4.png",
    "title": "Trung thu đong đầy - Đong đầy quà tặng",
    "date": "28/01/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DanhChoBan/img1.png",
    "title": "Đi càng đông ưu đãi càng nhiều chỉ có tại TMV",
    "date": "20/02/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DanhChoBan/img2.png",
    "title": "Tháng 3 làm đẹp thả ga - Đi 2 tính tiền 1",
    "date": "04/03/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DanhChoBan/img3.png",
    "title": "Trao nhan sắc - Gửi yêu thương siêu ưu đãi",
    "date": "12/02/2023"
  },
  {
    "img": "assets/images/Services/UuDai/DanhChoBan/img4.png",
    "title": "Trung thu đong đầy - Đong đầy quà tặng",
    "date": "28/01/2023"
  },
];

int activeChiNhanh = -1;
List chiNhanh = ["TP Hồ Chí Minh", "Hà Nội", "Đà Nẵng", "Cần Thơ"];

class _UuDaiScreenState extends State<UuDaiScreen> {
  final LocalStorage storage = LocalStorage('auth');
  void chooseChiNhanh(int index) {
    setState(() {
      activeChiNhanh = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print("Code" + " " + storage.getItem("city_code").toString());
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 0,
            // ),
            appBar: AppBar(
              centerTitle: true,
              bottomOpacity: 0.0,
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.west,
                  size: 24,
                  color: Colors.black,
                ),
              ),
              title: const Text("Ưu đãi",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            drawer: const MyLeftMenu(),
            body: SingleChildScrollView(
              // reverse: true,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Chi nhánh áp dụng:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.only(
                                          left: 20, right: 10)),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                ),
                                onPressed: () {
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ModalChiNhanh(
                                            chooseChiNhanh: (index) =>
                                                chooseChiNhanh(index),
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      activeChiNhanh < 0
                                          ? "Chọn chi nhánh"
                                          : "${chiNhanh[activeChiNhanh]}",
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 40),
                      child: const Text(
                        "Uư đãi đặc biệt",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 170,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: uudaidatbiet.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(left: index != 0 ? 15 : 0),
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(7)),
                                      child: Image.asset(
                                        uudaidatbiet[index]["img"],
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${uudaidatbiet[index]["title"]}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Color(0xFF504F4F),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${uudaidatbiet[index]["date"]}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF8B8B8B),
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: const Text(
                        "Uư đãi dành cho bạn",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 15,
                        runSpacing: 10,
                        children: uudaidanhchoban.map((item) {
                          // int index = uudaidanhchoban.indexOf(item);
                          return InkWell(
                            onTap: () {},
                            child: SizedBox(
                                height: 170,
                                width: MediaQuery.of(context).size.width / 2 -
                                    22.5,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(7)),
                                      child: Image.asset(
                                        item["img"],
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${item["title"]}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Color(0xFF504F4F),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${item["date"]}",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF8B8B8B),
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                )),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
