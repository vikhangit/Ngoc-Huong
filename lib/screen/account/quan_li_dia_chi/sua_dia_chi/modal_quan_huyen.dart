import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/modal_phuong_xa.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/modal_thanh_pho.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/sua_dia_chi.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalQuanHuyen extends StatefulWidget {
  final Function saveAddress;
  final String district;
  const ModalQuanHuyen(
      {super.key, required this.saveAddress, required this.district});

  @override
  State<ModalQuanHuyen> createState() => _ModalDiaDiemState();
}

String districtId = "";
String activeDistrict = "";
String districtType = "";
String valueSearch = "";

class _ModalDiaDiemState extends State<ModalQuanHuyen> {
  final LocalStorage storage = LocalStorage('auth');
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController(text: valueSearch);
    callDistrictApi(provinceId).then((value) =>
        setState(() => districtId = value[value.indexWhere((element) {
              return element["district_name"] == widget.district;
            })]["district_id"]));
    setState(() {
      activeDistrict = widget.district;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    valueSearch = "";
    super.dispose();
  }

  void changeAddress(String id, String name) {
    setState(() {
      districtId = id;
      districtController = TextEditingController(text: name);
      wardController = TextEditingController(text: "");
      activeDistrict = name;
      wardId = "";
      activeWard = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              "Chọn quận/huyện",
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
            future: callDistrictApi(provinceId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: snapshot.data!.map((item) {
                        if (item["district_name"]
                            .toString()
                            .replaceAll(item["district_type"], "")
                            .toLowerCase()
                            .contains(valueSearch.toLowerCase())) {
                          return Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                changeAddress(
                                    item["district_id"], item["district_name"]);
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
                                    "${item["district_name"]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  if (districtId == item["district_id"])
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }).toList()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          districtId.isNotEmpty
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
