import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/account/setting/custom_switch.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';

class SettingAccout extends StatefulWidget {
  const SettingAccout({super.key});

  @override
  State<SettingAccout> createState() => _SettingAccoutState();
}

bool enableSecurity = false;
bool enableNotifications = true;

class _SettingAccoutState extends State<SettingAccout> {
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final CustomModal customModal = CustomModal();
  void saveAddress() {
    setState(() {});
  }

  void handleLogout() {
    customModal.showAlertDialog(
        context, "error", "Đang xuất", "Bạn có chắc chắn muốn đăng xuất không?",
        () {
      EasyLoading.show(status: "Đang xử lý...");
      Future.delayed(const Duration(seconds: 1), () {
        storageCustomerToken.deleteItem("customer_token").then((value) {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          EasyLoading.dismiss();
        });
      });
    }, () => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 3,
            // ),
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
              title: const Text("Cài đặt",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: Column(
              children: [
                Expanded(
                    child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    GestureDetector(
                        child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/account/cai-dat.png",
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bảo mật",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Touch ID, Face ID",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black54),
                                  ),
                                ],
                              )
                            ],
                          ),
                          CustomSwitch(
                            value: enableSecurity,
                            onChanged: (bool val) {
                              setState(() {
                                enableSecurity = val;
                              });
                            },
                          )
                        ],
                      ),
                    )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 80,
                            child: GestureDetector(
                                child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 22),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/icon/notifications-black.png",
                                    width: 28,
                                    height: 28,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Thông báo",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Ưu đãi, Khuyến mãi",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),
                          ),
                          Expanded(
                              flex: 15,
                              child: CustomSwitch(
                                value: enableNotifications,
                                onChanged: (bool val) {
                                  setState(() {
                                    enableNotifications = val;
                                  });
                                },
                              ))
                        ]),
                    // TextButton(
                    //     onPressed: () {
                    //       showModalBottomSheet<void>(
                    //           backgroundColor: Colors.white,
                    //           shape: const RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.vertical(
                    //               top: Radius.circular(15.0),
                    //             ),
                    //           ),
                    //           clipBehavior: Clip.antiAliasWithSaveLayer,
                    //           context: context,
                    //           isScrollControlled: true,
                    //           builder: (BuildContext context) {
                    //             return Container(
                    //                 padding: EdgeInsets.only(
                    //                     bottom: MediaQuery.of(context)
                    //                         .viewInsets
                    //                         .bottom),
                    //                 height: MediaQuery.of(context).size.height *
                    //                     0.88,
                    //                 child: ModalDiaDiem(
                    //                   saveAddress: saveAddress,
                    //                 ));
                    //           });
                    //     },
                    //     style: ButtonStyle(
                    //         padding: MaterialStateProperty.all(
                    //       const EdgeInsets.symmetric(
                    //           horizontal: 15, vertical: 20),
                    //     )),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Image.asset(
                    //               "assets/images/account/dia-chi.png",
                    //               width: 28,
                    //               height: 28,
                    //             ),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             const Text(
                    //               "Địa điểm của bạn",
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w300,
                    //                   color: Colors.black),
                    //             )
                    //           ],
                    //         ),
                    //         FutureBuilder(
                    //           future: callProvinceApi(),
                    //           builder: (context, snapshot) {
                    //             if (snapshot.hasData) {
                    //               return Row(
                    //                   children: snapshot.data!.map((item) {
                    //                 return Row(
                    //                   children: [
                    //                     if (item["province_id"]
                    //                         .toString()
                    //                         .contains(storageAuth
                    //                             .getItem("city_code")))
                    //                       Row(
                    //                         children: [
                    //                           Text(
                    //                             item["province_name"]
                    //                                 .toString()
                    //                                 .replaceAll("Tỉnh", "")
                    //                                 .replaceAll(
                    //                                     "Thành phố", ""),
                    //                             style: const TextStyle(
                    //                                 fontSize: 14,
                    //                                 fontWeight: FontWeight.w300,
                    //                                 color: Colors.black54),
                    //                           ),
                    //                           const Icon(
                    //                             Icons.keyboard_arrow_right,
                    //                             color: Colors.black54,
                    //                           )
                    //                         ],
                    //                       )
                    //                   ],
                    //                 );
                    //               }).toList());
                    //             } else {
                    //               return const Center(
                    //                 child: CircularProgressIndicator(),
                    //               );
                    //             }
                    //           },
                    //         ),
                    //       ],
                    //     )),

                    GestureDetector(
                        child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/delete-black.png",
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Xóa tài khoản",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          )
                        ],
                      ),
                    )),
                    GestureDetector(
                        onTap: () {
                          handleLogout();
                        },
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/account/dang-xuat.png",
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Đăng xuất",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        )),
                  ],
                ))
              ],
            )));
  }
}
