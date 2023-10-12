import 'dart:convert';
import 'dart:io';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/account/buy_history/buy_history.dart';
import 'package:ngoc_huong/screen/account/dieu_khoan_sd/dieu_khoan_sd.dart';
import 'package:ngoc_huong/screen/account/gioi_thieu_ban_be/gioi_thieu_ban_be.dart';
import 'package:ngoc_huong/screen/account/tran_history/tran_history.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';
import 'package:open_file/open_file.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

List menu = [
  {
    "icon": "assets/images/account/thong-tin.png",
    "title": "Thông tin tài khoản",
  },
  // {
  //   "icon": "assets/images/account/giao-dich.png",
  //   "title": "Lịch sử giao dịch",
  // },
  {
    "icon": "assets/images/account/dat-lich.png",
    "title": "Lịch sử làm đep",
  },
  {
    "icon": "assets/images/cart-black.png",
    "title": "Lịch sử đặt hàng",
  },
  {
    "icon": "assets/images/account/dieu-khoan.png",
    "title": "Điều khoản sử dụng",
  },
  {
    "icon": "assets/images/account/gioi-thieu.png",
    "title": "Giới thiệu bạn bè",
  },
  // {
  //   "icon": "assets/images/account/dia-chi.png",
  //   "title": "Quản lý địa chỉ",
  // },

  {
    "icon": "assets/images/account/ve-chung-toi.png",
    "title": "Về Ngọc Hường",
  },
  {
    "icon": "assets/images/account/dang-xuat.png",
    "title": "Đăng xuất",
  },
];

class _AccountScreenState extends State<AccountScreen> {
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final ProfileModel profileModel = ProfileModel();
  final OrderModel orderModel = OrderModel();
  final CustomModal customModal = CustomModal();
  void _openFile(PlatformFile file) {
    print(file.path);
    OpenFile.open(file.path);
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    // final file = result.files.first;
    File file = File(result.files.first.path!);
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = "data:image/jpeg;base64,${base64Encode(fileInByte)}";
    EasyLoading.show(status: "Vui lòng chờ...");
    Future.delayed(const Duration(seconds: 2), () {
      profileModel.setProfileIamge(fileInBase64).then((value) {
        EasyLoading.dismiss();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AccountScreen()));
        setState(() {
          ElegantNotification.success(
            width: MediaQuery.of(context).size.width,
            height: 50,
            notificationPosition: NotificationPosition.topCenter,
            toastDuration: const Duration(milliseconds: 2000),
            animation: AnimationType.fromTop,
            // title: const Text('Cập nhật'),
            description: const Text(
              'Cập nhập ảnh đại diện thành công',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
            onDismiss: () {},
          ).show(context);
        });
      });
    });
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
    void goAction(int index) {
      print(index);
      switch (index) {
        case 0:
          Navigator.pushNamed(context, "informationAccount");
          break;
        // case 1:
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => const TranHistory()));
        //   break;
        case 1:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BookingHistory()));
          break;
        case 2:
          orderModel.getStatusList().then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => BuyHistory(
                listTab: value,
              ))));

          break;
        case 3:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DieuKhoanSudung()));
          break;
        case 4:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GioiThieuBanBe()));
          break;
        case 5:
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const QuanLiDiaChi()));
          break;
        case 6:
          handleLogout();
          break;
        default:
      }
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: const MyBottomMenu(
            active: 3,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 25),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            makingPhoneCall();
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/call-black.png",
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("Hỗ trợ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400))
                            ],
                          )),
                    ),
                    Expanded(
                        child: FutureBuilder(
                            future: profileModel.getProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Center(
                                    child: Stack(children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                          backgroundColor: Colors.black,
                                          insetPadding:
                                              const EdgeInsets.all(20),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 350,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "${snapshot.data["CustomerImage"]}"),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xff00A3FF),
                                        backgroundImage: NetworkImage(
                                            "${snapshot.data["CustomerImage"]}"),
                                        radius: 35.0,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(90.0),
                                            color: Colors.blue[100]),
                                        child: GestureDetector(
                                            onTap: () {
                                              _pickFile();
                                            },
                                            child: Icon(
                                              Icons.linked_camera,
                                              size: 16,
                                              color: Colors.blue[600],
                                            ))),
                                  )
                                ]));
                              } else {
                                return const Center(
                                  child:
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: LoadingIndicator(
                                        colors: kDefaultRainbowColors,
                                        indicatorType:
                                            Indicator.lineSpinFadeLoader,
                                        strokeWidth: 1,
                                        // pathBackgroundColor: Colors.black45,
                                      ),
                                    ),
                                );
                              }
                            })),
                    Expanded(
                        child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 55,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4)),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.yellow[300],
                                size: 28,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text(
                                "0",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: profileModel.getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map profile = snapshot.data!;
                    return Column(
                      children: [
                        Text(profile["CustomerName"].toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w400)),
                        Text(profile["Phone"].toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300))
                      ],
                    );
                  } else {
                    return const Row(
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
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 47,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "hangthanhvien");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/2385/2385865.png",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Bạc",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  Text("Nâng hạng",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300))
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                  Expanded(flex: 6, child: Container()),
                  Expanded(
                      flex: 47,
                      child: GestureDetector(
                        onTap: () {
                          // showAlertDialog(context,
                          //     "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/3702/3702999.png",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Ưu đãi",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  Text("Dùng ngay",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300))
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 450,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Column(
                      children: menu.map((element) {
                        int index = menu.indexOf(element);
                        return SizedBox(
                          height: 60,
                          child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 15))),
                              onPressed: () {
                                goAction(index);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8))),
                                          child: Image.asset(
                                            element["icon"],
                                            width: 24,
                                            height: 24,
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                95,
                                        child: Text(
                                          "${element["title"]}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ),
                                  if (index < menu.length - 1)
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 55, top: 5),
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      color: Colors.grey.withOpacity(0.2),
                                      height: 1,
                                    )
                                ],
                              )),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              Container(height: 25,)
            ],
          )),
    );
  }
}
