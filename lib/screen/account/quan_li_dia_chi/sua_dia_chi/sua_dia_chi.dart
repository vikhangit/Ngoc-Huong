import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/addressModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/quan_li_dia_chi.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/modal_phuong_xa.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/modal_quan_huyen.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/modal_thanh_pho.dart';
import 'package:ngoc_huong/screen/account/setting/custom_switch.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class SuaDiaChi extends StatefulWidget {
  final Map details;
  final List listAddress;
  final Function saveAddress;
  const SuaDiaChi(
      {super.key,
      required this.details,
      required this.listAddress,
      required this.saveAddress});

  @override
  State<SuaDiaChi> createState() => _QuanLiDiaChiState();
}

String address = "";
bool isDefault = false;
List<String> items = ["Nhà riêng", "Văn phòng"];
String typeAdress = items[0];
String provinceId = "";
String activeCity = "";
String districtId = "";
String activeDistrict = "";
String wardId = "";
String activeWard = "";

TextEditingController cityController = TextEditingController();
TextEditingController districtController = TextEditingController();
TextEditingController wardController = TextEditingController();
TextEditingController addressController = TextEditingController();

class _QuanLiDiaChiState extends State<SuaDiaChi> {
  final AddressModel addressModel = AddressModel();
  final ProfileModel profileModel = ProfileModel();
  final CustomModal customModal = CustomModal();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    cityController =
        TextEditingController(text: widget.details["ProvinceName"]);
    districtController =
        TextEditingController(text: widget.details["DistrictName"]);
    wardController = TextEditingController(text: widget.details["WardName"]);
    addressController =
        TextEditingController(text: widget.details["ApartmentNumber"]);
    setState(() {
      provinceId =
          "${widget.details["ProvinceId"].toString().length == 1 ? "0" : ""}${widget.details["ProvinceId"]}";
      districtId =
          "${widget.details["DistrictId"].toString().length == 1 ? "00" : widget.details["DistrictId"].toString().length == 2 ? "0" : ""}${widget.details["DistrictId"]}";
      wardId =
          "${widget.details["WardId"].toString().length == 1 ? "0000" : widget.details["WardId"].toString().length == 2 ? "000" : widget.details["WardId"].toString().length == 3 ? "00" : widget.details["WardId"].toString().length == 4 ? "0" : ""}${widget.details["WardId"]}";
      typeAdress = widget.details["Type"] != null
          ? items.indexOf(widget.details["Type"]) > 0
              ? items[items.indexOf(widget.details["Type"])]
              : items[0]
          : items[0];
      isDefault = widget.details["IsDefault"] == true ? true : false;
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    districtController.dispose();
    wardController.dispose();
    scrollController.dispose();
    address = "";
    super.dispose();
  }

  void editAddress() async {
    FocusManager.instance.primaryFocus!.unfocus();
    final isValid = _formKey.currentState!.validate();
    Map data = {
      "Id": widget.details["Id"],
      "Type": typeAdress,
      "ApartmentNumber": addressController.text,
      "ProvinceId": provinceId,
      "DistrictId": districtId,
      "WardId": wardId,
      "IsDefault": isDefault
    };
    if (!isValid) {
      return;
    } else {
      customModal.showAlertDialog(context, "error", "Sửa địa chỉ",
          "Bạn có chắc chắn sửa địa chỉ này không?", () {
        EasyLoading.show(status: "Vui lòng chờ...");
        Navigator.pop(context);
        if (isDefault == true) {
          if (widget.listAddress.isNotEmpty) {
            for (var i = 0; i < widget.listAddress.length; i++) {
              addressModel.updateCustomerAddress({
                ...widget.listAddress[i],
                "IsDefault": false,
              });
            }
          }
        }
        Future.delayed(const Duration(seconds: 2), () {
          addressModel.updateCustomerAddress(data).then((value) => setState(() {
                EasyLoading.dismiss();
                Navigator.pop(context);
                widget.saveAddress();
              }));
        });
      }, () => Navigator.pop(context));
    }
  }

  void saveAddress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.details);
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
        editAddress();
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
      bottom: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
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
            title: const Text("Sửa địa chỉ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          bottomNavigationBar: ScrollToHide(
                        scrollController: scrollController,
                        height: 100,
                        child: const MyBottomMenu(
                          active: 4,
                        )),
          body: SizedBox(
              child: FutureBuilder(
                  future: profileModel.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: ListView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 7),
                                            child: const Text(
                                              "Loại địa chỉ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              focusedBorder: border,
                                              errorBorder: border,
                                              focusedErrorBorder: border,
                                              enabledBorder: border2,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5,
                                                      right: 15,
                                                      top: 18,
                                                      bottom: 18),
                                              suffixIcon:
                                                  DropdownButtonFormField(
                                                value: typeAdress,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    typeAdress = newValue!;
                                                  });
                                                },
                                                decoration: const InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .white))),
                                                items: items.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 7),
                                            child: const Text(
                                              "Họ Tên",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Vui lòng nhập tên';
                                              }
                                              return null;
                                            },
                                            readOnly: true,
                                            controller: TextEditingController(
                                                text: snapshot
                                                    .data!["CustomerName"]),
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
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5,
                                                      right: 15,
                                                      top: 18,
                                                      bottom: 18),
                                              prefix: const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15.0)),
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  fontWeight: FontWeight.w400),
                                              hintText: 'Nhập tên',
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 7),
                                            child: const Text(
                                              "Số điện thoại",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            readOnly: true,
                                            controller: TextEditingController(
                                                text: snapshot.data!["Phone"]),
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
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5,
                                                      right: 15,
                                                      top: 18,
                                                      bottom: 18),
                                              prefix: const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15.0)),
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  fontWeight: FontWeight.w400),
                                              hintText: 'Nhập số điện thoại',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 7),
                                            child: const Text(
                                              "Tỉnh/Thành Phố",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            readOnly: true,
                                            controller: cityController,
                                            onTap: () {
                                              showModalBottomSheet<void>(
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                        child: ModalThanhPho(
                                                          saveAddress:
                                                              saveAddress,
                                                          // cityId: widget
                                                          //     .details["ProvinceId"].toString(),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 7),
                                            child: const Text(
                                              "Quận/Huyện",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            readOnly: true,
                                            controller: districtController,
                                            onTap: () {
                                              showModalBottomSheet<void>(
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                        child: ModalQuanHuyen(
                                                            saveAddress:
                                                                saveAddress));
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 7),
                                            child: const Text(
                                              "Phường/Xã",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            readOnly: true,
                                            controller: wardController,
                                            onTap: () {
                                              showModalBottomSheet<void>(
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                        child: ModalPhuongXa(
                                                          saveAddress:
                                                              saveAddress,
                                                          wardId: widget
                                                              .details["WardId"]
                                                              .toString(),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 7),
                                            child: const Text(
                                              "Địa chỉ cụ thể",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          TextFormField(
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            // validator: (value) {
                                            //   if (value == null || value.isEmpty) {
                                            //     return 'Vui lòng nhập tên';
                                            //   }
                                            //   return null;
                                            // },
                                            controller: addressController,
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
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5,
                                                      right: 15,
                                                      top: 18,
                                                      bottom: 18),
                                              prefix: const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15.0)),
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black
                                                      .withOpacity(0.3),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                    // onLoading();
                                    editAddress();
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
                          ));
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
                  }))),
    );
  }
}
