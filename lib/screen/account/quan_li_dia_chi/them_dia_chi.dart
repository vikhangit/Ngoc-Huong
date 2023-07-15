import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/modal_phuong_xa.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/modal_quan_huyen.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/modal_thanh_pho.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/quan_li_dia_chi.dart';
import 'package:ngoc_huong/screen/account/setting/custom_switch.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ThemDiaChi extends StatefulWidget {
  const ThemDiaChi({super.key});

  @override
  State<ThemDiaChi> createState() => _QuanLiDiaChiState();
}

String address = "";
bool isDefault = true;
List<String> items = ["Nhà riêng", "Văn phòng"];
String typeAdress = items[0];

class _QuanLiDiaChiState extends State<ThemDiaChi> {
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  LocalStorage storage = LocalStorage("auth");
  LocalStorage storageToken = LocalStorage('token');
  @override
  void initState() {
    super.initState();
    cityController = TextEditingController(text: activeCity);
    districtController = TextEditingController(text: activeDistrict);
    wardController = TextEditingController(text: activeWard);
  }

  @override
  void dispose() {
    cityController.dispose();
    districtController.dispose();
    wardController.dispose();

    address = "";
    super.dispose();
  }

  void addAddress() async {
    Map data = {
      "address": address,
      "city": activeCity,
      "ward": activeWard,
      "district": activeDistrict,
      "exfields": {"type_address": typeAdress, "is_default": isDefault}
    };
    await postAddress(data).then((value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const QuanLiDiaChi()));
      setState(() {
        activeCity = "";
        provinceId = "";
        activeDistrict = "";
        districtId = "";
        activeWard = "";
        wardId = "";
      });
    });
  }

  void saveAddress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(storageToken.getItem("token"));
    void onLoading() {
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
        addAddress();
        Navigator.pop(context);
      });
    }

    var border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.primary), //<-- SEE HERE
    );
    var border2 = const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1, color: Colors.grey));
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
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
            title: const Text("Thêm địa chỉ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          drawer: const MyLeftMenu(),
          body: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Loại địa chỉ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            FutureBuilder(
                              future: getProfile(storage.getItem("phone")),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      focusedBorder: border,
                                      errorBorder: border,
                                      focusedErrorBorder: border,
                                      enabledBorder: border2,
                                      contentPadding: const EdgeInsets.only(
                                          left: 5,
                                          right: 15,
                                          top: 18,
                                          bottom: 18),
                                      suffixIcon: DropdownButtonFormField(
                                        value: typeAdress,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        onChanged: (newValue) {
                                          setState(() {
                                            typeAdress = newValue!;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white))),
                                        items: items
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
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
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Họ Tên",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            FutureBuilder(
                              future: getProfile(storage.getItem("phone")),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập tên';
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: snapshot.data![0]["ten_kh"]),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      focusedBorder: border,
                                      errorBorder: border,
                                      focusedErrorBorder: border,
                                      enabledBorder: border2,
                                      contentPadding: const EdgeInsets.only(
                                          left: 5,
                                          right: 15,
                                          top: 18,
                                          bottom: 18),
                                      prefix: const Padding(
                                          padding: EdgeInsets.only(left: 15.0)),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w400),
                                      hintText: 'Nhập tên',
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
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Số điện thoại",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            FutureBuilder(
                              future: getProfile(storage.getItem("phone")),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: snapshot.data![0]["of_user"]),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      focusedBorder: border,
                                      errorBorder: border,
                                      focusedErrorBorder: border,
                                      enabledBorder: border2,
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      contentPadding: const EdgeInsets.only(
                                          left: 5,
                                          right: 15,
                                          top: 18,
                                          bottom: 18),
                                      prefix: const Padding(
                                          padding: EdgeInsets.only(left: 15.0)),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w400),
                                      hintText: 'Nhập số điện thoại',
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
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Tỉnh/Thành Phố",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              readOnly: true,
                              controller:
                                  TextEditingController(text: activeCity),
                              onTap: () {
                                showModalBottomSheet<void>(
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.0),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
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
                                              0.88,
                                          child: ModalThanhPho(
                                            saveAddress: saveAddress,
                                          ));
                                    });
                              },
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                focusedBorder: border,
                                errorBorder: border,
                                focusedErrorBorder: border,
                                enabledBorder: border2,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Quận/Huyện",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              readOnly: true,
                              controller:
                                  TextEditingController(text: activeDistrict),
                              onTap: () {
                                if (activeCity.isNotEmpty &&
                                    provinceId.isNotEmpty) {
                                  showModalBottomSheet<void>(
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      context: context,
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
                                                0.88,
                                            child: ModalQuanHuyen(
                                              saveAddress: saveAddress,
                                            ));
                                      });
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                focusedBorder: border,
                                errorBorder: border,
                                focusedErrorBorder: border,
                                enabledBorder: border2,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Phường/Xã",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              readOnly: true,
                              controller:
                                  TextEditingController(text: activeWard),
                              onTap: () {
                                if (activeCity.isNotEmpty &&
                                    provinceId.isNotEmpty &&
                                    activeDistrict.isNotEmpty &&
                                    districtId.isNotEmpty) {
                                  showModalBottomSheet<void>(
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      context: context,
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
                                                0.88,
                                            child: ModalPhuongXa(
                                              saveAddress: saveAddress,
                                            ));
                                      });
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                focusedBorder: border,
                                errorBorder: border,
                                focusedErrorBorder: border,
                                enabledBorder: border2,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                "Địa chỉ cụ thể",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Vui lòng nhập tên';
                              //   }
                              //   return null;
                              // },
                              onChanged: (value) {
                                setState(() {
                                  address = value;
                                });
                              },
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                focusedBorder: border,
                                errorBorder: border,
                                focusedErrorBorder: border,
                                enabledBorder: border2,
                                contentPadding: const EdgeInsets.only(
                                    left: 5, right: 15, top: 18, bottom: 18),
                                prefix: const Padding(
                                    padding: EdgeInsets.only(left: 15.0)),
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.3),
                                    fontWeight: FontWeight.w400),
                                hintText: '',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Đặt làm mặc định",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            CustomSwitch(
                              value: isDefault,
                              onChanged: (bool val) {
                                setState(() {
                                  isDefault = val;
                                });
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: TextButton(
                    onPressed: () {
                      onLoading();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20))),
                    child: const Center(
                      child: Text(
                        "Lưu địa chỉ",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
