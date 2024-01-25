import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/addressModel.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/sua_dia_chi.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/them_dia_chi.dart';
import 'package:ngoc_huong/screen/checkout/products/checkout_cart.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:upgrader/upgrader.dart';

class ChooseAddressShipping extends StatefulWidget {
  final Function saveAddress;
  const ChooseAddressShipping({super.key, required this.saveAddress});

  @override
  State<ChooseAddressShipping> createState() => _ChooseAddressShippingState();
}

int activeIndex = -1;

class _ChooseAddressShippingState extends State<ChooseAddressShipping> {
  final AddressModel addressModel = AddressModel();
  final CustomModal customModal = CustomModal();
  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void saveAddress() {
    setState(() {});
  }

  void deleteAddressByID(int id) async {
    customModal.showAlertDialog(
        context, "error", "Xóa địa chỉ", "Bạn có chắc chắn xóa địa chỉ này?",
        () {
      EasyLoading.show(status: "Vui lòng chờ");
      Navigator.of(context).pop();
      Future.delayed(const Duration(seconds: 2), () {
        addressModel.deleteCustomerAddress(id).then((value) => setState(() {
              EasyLoading.dismiss();
            }));
      });
    }, () => Navigator.of(context).pop());
  }

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
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
            title: const Text("Chọn địa chỉ nhận hàng",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: FutureBuilder(
                      future: addressModel.getCustomerAddress(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List list = snapshot.data!.toList();
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              list.isNotEmpty
                                  ? Expanded(
                                      child: RefreshIndicator(
                                      onRefresh: () => refreshData(),
                                      child: ListView(
                                          children: list.map((item) {
                                        int index = list.indexOf(item);
                                        return GestureDetector(
                                          onTap: () => setState(() {
                                            activeIndex = index;
                                            selectAddress =
                                                "${item["ApartmentNumber"]}, ${item["WardName"]}, ${item["DistrictName"]}, ${item["ProvinceName"]}";
                                            Navigator.of(context).pop();
                                            widget.saveAddress();
                                          }),
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15),
                                              margin: EdgeInsets.only(
                                                  top: index == 0 ? 0 : 10),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: Colors
                                                              .grey[300]!))),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 7,
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 28,
                                                        height: 28,
                                                        decoration: BoxDecoration(
                                                            color: activeIndex ==
                                                                    index
                                                                ? Colors.green
                                                                : Colors.white,
                                                            border: Border.all(
                                                                width: 1,
                                                                color: activeIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .black),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        child:
                                                            activeIndex == index
                                                                ? const Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 18,
                                                                  )
                                                                : null),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Container(),
                                                  ),
                                                  Expanded(
                                                      flex: 88,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => SuaDiaChi(
                                                                                  details: item,
                                                                                  listAddress: list,
                                                                                  saveAddress: saveAddress,
                                                                                )));
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Sửa",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                  )),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    deleteAddressByID(
                                                                        item[
                                                                            "Id"]);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Xóa",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ))
                                                            ],
                                                          ),
                                                          Text(
                                                            "${item["ApartmentNumber"]}, ${item["WardName"]}, ${item["DistrictName"]}, ${item["ProvinceName"]}",
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          item["IsDefault"] ==
                                                                  true
                                                              ? Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/location-green.png",
                                                                      width: 24,
                                                                      height:
                                                                          24,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    const Text(
                                                                      "Địa chỉ mặc định",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color:
                                                                              Color(0xFF1CC473)),
                                                                    )
                                                                  ],
                                                                )
                                                              : Container()
                                                        ],
                                                      ))
                                                ],
                                              )),
                                        );
                                      }).toList()),
                                    ))
                                  : Container(
                                      margin: const EdgeInsets.only(
                                          top: 40, bottom: 15),
                                      child: Image.asset(
                                          "assets/images/account/img.webp"),
                                    ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ThemDiaChi(
                                                  listAddress:
                                                      snapshot.data!.toList(),
                                                  save: saveAddress,
                                                )));
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary),
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
                              )
                            ],
                          );
                        } else {
                          return const Center(
                            child: Row(
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
                      })))),
    );
  }
}
