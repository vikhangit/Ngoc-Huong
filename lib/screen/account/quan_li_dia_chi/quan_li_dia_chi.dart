import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/addressModel.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/sua_dia_chi/sua_dia_chi.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/them_dia_chi.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class QuanLiDiaChi extends StatefulWidget {
  const QuanLiDiaChi({super.key});

  @override
  State<QuanLiDiaChi> createState() => _QuanLiDiaChiState();
}

class _QuanLiDiaChiState extends State<QuanLiDiaChi> {
  final AddressModel addressModel = AddressModel();
  final CustomModal customModal = CustomModal();
  final ScrollController scrollController = ScrollController();

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void save() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: ScrollToHide(
              scrollController: scrollController,
              height: 100,
              child: const MyBottomMenu(
                active: 4,
              )),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: FutureBuilder(
                      future: addressModel.getCustomerAddress(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List list = snapshot.data!.toList();
                          if (list.isNotEmpty) {
                            return RefreshIndicator(
                              onRefresh: () => refreshData(),
                              child: ListView(
                                  controller: scrollController,
                                  children: list.map((item) {
                                    int index = list.indexOf(item);
                                    return Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        margin: EdgeInsets.only(
                                            top: index == 0 ? 0 : 10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey[300]!))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SuaDiaChi(
                                                                        details:
                                                                            item,
                                                                        listAddress:
                                                                            list,
                                                                        saveAddress:
                                                                            save,
                                                                      )));
                                                    },
                                                    child: const Text(
                                                      "Sửa",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      customModal.showAlertDialog(
                                                          context,
                                                          "error",
                                                          "Xóa địa chỉ",
                                                          "Bạn có chắc chắn xóa địa chỉ này?",
                                                          () {
                                                        EasyLoading.show(
                                                            status:
                                                                "Vui lòng chờ");
                                                        Navigator.of(context)
                                                            .pop();
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 2),
                                                            () {
                                                          addressModel
                                                              .deleteCustomerAddress(
                                                                  item["Id"])
                                                              .then((value) =>
                                                                  setState(() {
                                                                    EasyLoading
                                                                        .dismiss();
                                                                  }));
                                                        });
                                                      },
                                                          () => Navigator.pop(
                                                              context));
                                                    },
                                                    child: const Text(
                                                      "Xóa",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ))
                                              ],
                                            ),
                                            Text(
                                              "${item["ApartmentNumber"]}, ${item["WardName"]}, ${item["DistrictName"]}, ${item["ProvinceName"]}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            item["IsDefault"] == true
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
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Color(
                                                                0xFF1CC473)),
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
                              margin:
                                  const EdgeInsets.only(top: 40, bottom: 15),
                              child:
                                  Image.asset("assets/images/account/img.webp"),
                            );
                          }
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
                      },
                    )),
                    FutureBuilder(
                      future: addressModel.getCustomerAddress(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ThemDiaChi(
                                              listAddress:
                                                  snapshot.data!.toList(),
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
                          return Container();
                          // return const Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     SizedBox(
                          //       width: 40,
                          //       height: 40,
                          //       child: LoadingIndicator(
                          //         colors: kDefaultRainbowColors,
                          //         indicatorType: Indicator.lineSpinFadeLoader,
                          //         strokeWidth: 1,
                          //         // pathBackgroundColor: Colors.black45,
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     Text("Đang lấy dữ liệu")
                          //   ],
                          // );
                        }
                      },
                    )
                  ],
                ),
              ))),
    );
  }
}
