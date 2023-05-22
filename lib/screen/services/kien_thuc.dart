import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/modal/modal_chi_nhanh.dart';

class KienThucScreen extends StatefulWidget {
  const KienThucScreen({super.key});

  @override
  State<KienThucScreen> createState() => _KienThucScreenState();
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
    "img": "assets/images/Services/KienThuc/img1.jpg",
    "title": "Màu môi phun đẹp cho người da ngăm đẹp nhất",
    "date": "14/03/2023"
  },
  {
    "img": "assets/images/Services/KienThuc/img2.jpg",
    "title": "Cách làm mờ chân mày mới xăm đơn giản, hiệu quả",
    "date": "18/03/2023"
  },
  {
    "img": "assets/images/Services/KienThuc/img3.jpg",
    "title": "Tại sao môi trên thâm hơn môi dưới?",
    "date": "12/03/2023"
  },
  {
    "img": "assets/images/Services/KienThuc/img4.jpg",
    "title": "[Chi tiết] Thực đơn 7 ngày dành cho người xăm môi",
    "date": "09/03/2023"
  },
  {
    "img": "assets/images/Services/KienThuc/img5.jpg",
    "title": "Phun xăm môi đỏ cam xu hướng HOT TREND mới nhất",
    "date": "05/03/2023"
  },
  {
    "img": "assets/images/Services/KienThuc/img6.jpg",
    "title": "[14 Ngày] Cách chăm sóc môi sau phun lên màu chuẩn",
    "date": "21/02/2023"
  },
  {
    "img": "assets/images/Services/KienThuc/img7.jpg",
    "title": "[14 Ngày] Cách chăm sóc môi sau phun lên màu chuẩn",
    "date": "21/02/2023"
  },
  {
    "img": "assets/images/Services/KienThuc/img8.jpg",
    "title": "[14 Ngày] Cách chăm sóc môi sau phun lên màu chuẩn",
    "date": "21/02/2023"
  },
];

int activeChiNhanh = -1;
List chiNhanh = ["TP Hồ Chí Minh", "Hà Nội", "Đà Nẵng", "Cần Thơ"];

class _KienThucScreenState extends State<KienThucScreen> {
  void chooseChiNhanh(int index) {
    setState(() {
      activeChiNhanh = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text("Kiến thức làm đẹp",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            drawer: const MyLeftMenu(),
            body: SingleChildScrollView(
              // reverse: true,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 15,
                        runSpacing: 10,
                        children: uudaidanhchoban.map((item) {
                          // int index = uudaidanhchoban.indexOf(item);
                          return InkWell(
                            onTap: () {},
                            child: SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width / 2 -
                                    22.5,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14)),
                                      child: Image.asset(
                                        item["img"],
                                        height: 135,
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
                                          color: Color(0xFF212121),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
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
