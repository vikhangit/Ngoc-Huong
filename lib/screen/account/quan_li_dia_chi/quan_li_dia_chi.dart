import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/sua_dia_chi.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/them_dia_chi.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class QuanLiDiaChi extends StatefulWidget {
  const QuanLiDiaChi({super.key});

  @override
  State<QuanLiDiaChi> createState() => _QuanLiDiaChiState();
}

class _QuanLiDiaChiState extends State<QuanLiDiaChi> {
  LocalStorage storage = LocalStorage('token');

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void save() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void deleteAddressByID(String id) async {
      await deleteAddress(id).then((value) => setState(() {}));
    }

    void onLoading(String id) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        deleteAddressByID(id);
        Navigator.pop(context);
      });
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountScreen()));
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
            title: const Text("Quản lý địa chỉ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          drawer: const MyLeftMenu(),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: FutureBuilder(
                  future: getAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.toList();
                      if (list.isNotEmpty) {
                        return RefreshIndicator(
                          onRefresh: () => refreshData(),
                          child: ListView(
                              children: list.map((item) {
                            int index = list.indexOf(item);
                            return Container(
                                padding: const EdgeInsets.only(bottom: 15),
                                margin:
                                    EdgeInsets.only(top: index == 0 ? 0 : 10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Colors.grey[300]!))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SuaDiaChi(
                                                            details: item,
                                                            listAddress: list,
                                                            saveAddress: save,
                                                          )));
                                            },
                                            child: const Text(
                                              "Sửa",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              onLoading(item["_id"]);
                                            },
                                            child: const Text(
                                              "Xóa",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ))
                                      ],
                                    ),
                                    Text(
                                      "${item["address"]}, ${item["ward"]}, ${item["district"]}, ${item["city"]}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    item["exfields"]["is_default"] == true
                                        ? Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/location-green.png",
                                                width: 24,
                                                height: 24,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              const Text(
                                                "Địa chỉ mặc định",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color(0xFF1CC473)),
                                              )
                                            ],
                                          )
                                        : Container()
                                  ],
                                ));
                          }).toList()),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.only(top: 40, bottom: 15),
                          child: Image.asset("assets/images/account/img.webp"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )),
                FutureBuilder(
                  future: getAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ThemDiaChi(
                                          listAddress: snapshot.data!.toList(),
                                          save: save,
                                        )));
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 20))),
                          child: const Center(
                            child: Text(
                              "Thêm địa chỉ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
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
          )),
    );
  }
}
