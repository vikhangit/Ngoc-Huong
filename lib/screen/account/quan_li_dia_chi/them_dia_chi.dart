import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/addressModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/modal_phuong_xa.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/modal_quan_huyen.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/modal_thanh_pho.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/custom_switch.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class ThemDiaChi extends StatefulWidget {
  final List listAddress;
  final Function save;
  const ThemDiaChi({super.key, required this.listAddress, required this.save});

  @override
  State<ThemDiaChi> createState() => _QuanLiDiaChiState();
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

class _QuanLiDiaChiState extends State<ThemDiaChi> {
  final AddressModel addressModel = AddressModel();
  final ProfileModel profileModel = ProfileModel();
  final CustomModal customModal = CustomModal();
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    cityController = TextEditingController(text: activeCity);
    districtController = TextEditingController(text: activeDistrict);
    wardController = TextEditingController(text: activeWard);
    setState(() {
      provinceId = "";
      activeCity = "";
      districtId = "";
      wardId = "";
      activeDistrict = "";
      activeWard = "";
      isDefault = false;
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    districtController.dispose();
    wardController.dispose();
    scrollController.dispose();
    provinceId = "";
    activeCity = "";
    districtId = "";
    wardId = "";
    activeDistrict = "";
    activeWard = "";
    address = "";
    isDefault = false;
    super.dispose();
  }

  void addAddress() async {
    FocusManager.instance.primaryFocus!.unfocus();
    final isValid = _formKey.currentState!.validate();
    List listID = [];
    Map data = {
      "Type": typeAdress,
      "ProvinceId": provinceId,
      "DistrictId": districtId,
      "WardId": wardId,
      "ApartmentNumber": address,
      "IsDefault": isDefault
    };
    if (!isValid) {
      return;
    } else {
      customModal.showAlertDialog(context, "error", "Thêm địa chỉ",
          "Bạn có chắc chắn thêm địa chỉ này không?", () {
        EasyLoading.show(status: "Vui lòng chờ...");
        Navigator.of(context).pop();
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
          addressModel.setNewCustomerAddress(data).then((value) => setState(() {
                EasyLoading.dismiss();
                Navigator.of(context).pop();
                widget.save();
              }));
        });
      }, () => Navigator.of(context).pop());
    }
  }

  void saveAddress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            title: const Text("Thêm địa chỉ",
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
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: SizedBox(
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
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, bottom: 15),
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 7),
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
                                            suffixIcon: DropdownButtonFormField(
                                              dropdownColor: Colors.white,
                                              value: typeAdress,
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                              items: items.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
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
                                          margin:
                                              const EdgeInsets.only(bottom: 7),
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
                                          margin:
                                              const EdgeInsets.only(bottom: 7),
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
                                          margin:
                                              const EdgeInsets.only(bottom: 7),
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
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Vui lòng chọn tỉnh/thành phố";
                                            }
                                            return null;
                                          },
                                          controller: TextEditingController(
                                              text: activeCity),
                                          onTap: () {
                                            showModalBottomSheet<void>(
                                                backgroundColor: Colors.white,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(15.0),
                                                  ),
                                                ),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.8,
                                                      child: ModalThanhPho(
                                                        saveAddress:
                                                            saveAddress,
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
                                          margin:
                                              const EdgeInsets.only(bottom: 7),
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
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Vui lòng chọn quận/huyện";
                                            }
                                            return null;
                                          },
                                          controller: TextEditingController(
                                              text: activeDistrict),
                                          onTap: () {
                                            if (activeCity.isNotEmpty &&
                                                provinceId.isNotEmpty) {
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
                                                              saveAddress,
                                                        ));
                                                  });
                                            } else {
                                              customModal.showAlertDialog(
                                                  context,
                                                  "error",
                                                  "Lỗi",
                                                  "Vui lòng chọn tỉnh/thành phố trước",
                                                  () => Navigator.of(context)
                                                      .pop(),
                                                  () => Navigator.of(context)
                                                      .pop());
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 7),
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
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Vui lòng chọn phường/xã";
                                            }
                                            return null;
                                          },
                                          controller: TextEditingController(
                                              text: activeWard),
                                          onTap: () {
                                            if (activeCity.isNotEmpty &&
                                                provinceId.isNotEmpty &&
                                                activeDistrict.isNotEmpty &&
                                                districtId.isNotEmpty) {
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
                                                        ));
                                                  });
                                            } else {
                                              customModal.showAlertDialog(
                                                  context,
                                                  "error",
                                                  "Lỗi",
                                                  "Vui lòng chọn tỉnh/thành phố và phường/xã trước",
                                                  () => Navigator.of(context)
                                                      .pop(),
                                                  () => Navigator.of(context)
                                                      .pop());
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 7),
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
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Vui lòng địa chỉ cụ thể';
                                            }
                                            return null;
                                          },
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
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  addAddress();
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
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Đang lấy dữ liệu")
                          ]),
                    );
                  }
                },
              )))),
    );
  }
}
