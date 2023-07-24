import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/account/setting/custom_switch.dart';
import 'package:ngoc_huong/screen/account/setting/modal_change_pass.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class SettingAccout extends StatefulWidget {
  const SettingAccout({super.key});

  @override
  State<SettingAccout> createState() => _SettingAccoutState();
}

bool enableSecurity = false;
bool enableNotifications = true;

class _SettingAccoutState extends State<SettingAccout> {
  LocalStorage storageToken = LocalStorage("token");
  LocalStorage storageAuth = LocalStorage('auth');

  void saveAddress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void showAlertDialog(BuildContext context, String err) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () => Navigator.pop(context, 'OK'),
      );
      AlertDialog alert = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            return SizedBox(
              // height: 30,
              width: MediaQuery.of(context).size.width,
              child: Text(
                style: const TextStyle(height: 1.6),
                err,
              ),
            );
          },
        ),
        actions: [
          okButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

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
                Text("Loading"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () async {
        Navigator.pop(context);
        Navigator.pushNamed(context, "home");
        storageAuth.deleteItem("phone");
      });
    }

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
            drawer: const MyLeftMenu(),
            body: Column(
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    TextButton(
                        onPressed: () {
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.88,
                                  child: ModalChangePass(),
                                );
                              });
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                        )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/account/mat-khau.png",
                                  width: 28,
                                  height: 28,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Mật Khẩu",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  "Thay đổi",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black54,
                                )
                              ],
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          showAlertDialog(context,
                              "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                        )),
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
                        )),
                    TextButton(
                        onPressed: () {
                          AppSettings.openNotificationSettings();
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                        )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            CustomSwitch(
                              value: enableNotifications,
                              onChanged: (bool val) {
                                setState(() {
                                  enableNotifications = val;
                                });
                              },
                            )
                          ],
                        )),
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

                    TextButton(
                        onPressed: () {
                          showAlertDialog(context,
                              "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                        )),
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
                        )),
                    TextButton(
                        onPressed: () {
                          AlertDialog alert = AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                return SizedBox(
                                    // height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.info,
                                          size: 70,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Text(
                                          "Đăng xuất",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Bạn có muốn đăng xuất tài khoản không?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ));
                              },
                            ),
                            actionsPadding: const EdgeInsets.only(
                                top: 0, left: 30, right: 30, bottom: 30),
                            actions: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  onPressed: () => onLoading(),
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 15)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                  child: const Text(
                                    "Đồng ý",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 10),
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 15)),
                                    shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            side: BorderSide(
                                                color: Colors.grey, width: 1))),
                                  ),
                                  child: const Text("Hủy bỏ"),
                                ),
                              )
                            ],
                          );
                          // show the dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                        )),
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
                        )),
                  ],
                ))
              ],
            )));
  }
}
