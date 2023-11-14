import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/addressModel.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/modal_phuong_xa.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/modal_quan_huyen.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/sua_dia_chi.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/sua_dia_chi.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalThanhPho extends StatefulWidget {
  final Function saveAddress;
  // final String city;
  // final String cityId;
  const ModalThanhPho(
      {super.key, required this.saveAddress});

  @override
  State<ModalThanhPho> createState() => _ModalDiaDiemState();
}

String valueSearch = "";

class _ModalDiaDiemState extends State<ModalThanhPho> {
  final AddressModel addressModel = AddressModel();
  // final ProfileModel profileModel = ProfileModel();
  // final CustomModal customModal = CustomModal();
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController(text: valueSearch);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    valueSearch = "";
    // provinceId = "";
    // activeCity = "";
    super.dispose();
  }

  void changeAddress(String id, String name) {
    setState(() {
      cityController = TextEditingController(text: name);
      provinceId = id;
      activeCity = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(provinceId);
    return Container(
      padding: const EdgeInsets.all(15.0),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              "Chọn tỉnh/thành phố",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              autofocus: false,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (value) {
                setState(() {
                  valueSearch = value;
                });
              },
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search_outlined,
                  size: 30,
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      width: 1,
                      color:
                          Theme.of(context).colorScheme.primary), //<-- SEE HERE
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
                hintText: 'Nhập để tìm kiếm',
              ),
            ),
          ),
          FutureBuilder(
            future: addressModel.getProvinceApi(valueSearch),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: snapshot.data!.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              changeAddress(
                                  item["Id"], item["Name"]);
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${item["Name"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                if (provinceId == item["Id"])
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )

                              ],
                            ),
                          ),
                        );
                      }).toList()),
                );
              } else {
                return const Center(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: LoadingIndicator(
                          colors: kDefaultRainbowColors,
                          indicatorType: Indicator.lineSpinFadeLoader,
                          strokeWidth: 1,
                          // pathBackgroundColor: Colors.black45,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Đang lấy dữ liệu")
                    ],
                  ),
                );
              }
            },
          ),
          provinceId.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        districtController = TextEditingController(text: "");
                        wardController = TextEditingController(text: "");
                        districtId = "";
                        wardId = "";
                        activeDistrict = "";
                        activeWard = "";
                        widget.saveAddress();
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0.0))),
                      child: const Text("Xác nhận",
                          style: TextStyle(fontSize: 14, color: Colors.white))),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: const Text("Xác nhận",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                )
        ],
      ),
    );
  }
}
