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
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/memberModel.dart';
import 'package:ngoc_huong/models/order.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/account/about_us/AboutUs.dart';
import 'package:ngoc_huong/screen/account/beautify_history/beautify_history.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/account/buy_history/buy_history.dart';
import 'package:ngoc_huong/screen/account/dieu_khoan_sd/dieu_khoan_sd.dart';
import 'package:ngoc_huong/screen/account/gioi_thieu_ban_be/gioi_thieu_ban_be.dart';
import 'package:ngoc_huong/screen/account/my_order/my_order.dart';
import 'package:ngoc_huong/screen/account/quan_li_dia_chi/quan_li_dia_chi.dart';
import 'package:ngoc_huong/screen/account/tran_history/tran_history.dart';
import 'package:ngoc_huong/screen/gift_shop/gift_shop.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/member/thanh_vien.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';
import 'package:open_file/open_file.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

Map profile = {};
bool loading = true;

List menu = [
  {
    "icon": "assets/images/account/thong-tin.png",
    "title": "Thông tin tài khoản",
  },
  {
    "icon": "assets/images/account/dat-lich.png",
    "title": "Lịch sử đặt lịch",
  },
  {"icon": "assets/images/TimeCircleBlack.png", "title": "Lịch sử làm đẹp"},
  {
    "icon": "assets/images/cart-black.png",
    "title": "Lịch sử mua hàng",
  },
  // {
  //   "icon": "assets/images/account/giao-dich.png",
  //   "title": "Đơn hàng của tôi",
  // },
  {
    "icon": "assets/images/icon/Xu1.png",
    "title": "Lịch sử giao dịch xu",
  },
  {
    "icon": "assets/images/account/dia-chi.png",
    "title": "Quản lý địa chỉ",
  },
  {
    "icon": "assets/images/account/gioi-thieu.png",
    "title": "Giới thiệu bạn bè",
  },
  {
    "icon": "assets/images/account/ve-chung-toi.png",
    "title": "Về Ngọc Hường Beauty",
  },
  {
    "icon": "assets/images/account/dieu-khoan.png",
    "title": "Điều khoản sử dụng",
  },
  {
    "icon": "assets/images/delete-black.png",
    "title": "Xóa tài khoản",
  },
  {
    "icon": "assets/images/account/dang-xuat.png",
    "title": "Đăng xuất",
  },
];

List rank = [];

class _AccountScreenState extends State<AccountScreen> {
  final LocalStorage storageCustomerToken = LocalStorage('customer_token');
  final ProfileModel profileModel = ProfileModel();
  final OrderModel orderModel = OrderModel();
  final CustomModal customModal = CustomModal();
  final BookingModel bookingModel = BookingModel();
  final MemberModel memberModel = MemberModel();
  final ScrollController scrollController = ScrollController();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
    profileModel.getProfile().then((value) {
      setState(() {
        profile = value;
      });
    });
    memberModel.getAllRank().then((value) => setState(() {
          rank = value.toList();
        }));
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  void handleLogout() {
    customModal.showAlertDialog(
        context, "error", "Đang xuất", "Bạn có chắc chắn muốn đăng xuất không?",
        () {
      EasyLoading.show(status: "Đang xử lý...");
      storageCustomerToken.deleteItem("customer_token");
      Future.delayed(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    }, () => Navigator.of(context).pop());
  }

  Widget checkRank(int point) {
    if (point >= rank[0]["PointUpLevel"] && point < rank[1]["PointUpLevel"]) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(
                        ac: 0,
                      )));
        },
        child: Image.network(
          "${rank[0]["Image"]}",
          width: MediaQuery.of(context).size.width,
          height: 190,
        ),
      );
    } else if (point >= rank[1]["PointUpLevel"] &&
        point < rank[2]["PointUpLevel"]) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(
                        ac: 1,
                      )));
        },
        child: Image.network(
          "${rank[1]["Image"]}",
          width: MediaQuery.of(context).size.width,
          height: 190,
        ),
      );
    } else if (point >= rank[2]["PointUpLevel"] &&
        point < rank[3]["PointUpLevel"]) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(
                        ac: 2,
                      )));
        },
        child: Image.network(
          "${rank[2]["Image"]}",
          width: MediaQuery.of(context).size.width,
          height: 190,
        ),
      );
    } else if (point >= rank[3]["PointUpLevel"]) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(
                        ac: 3,
                      )));
        },
        child: Image.network(
          "${rank[3]["Image"]}",
          width: MediaQuery.of(context).size.width,
          height: 190,
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThanhVienScreen(
                        ac: 0,
                      )));
        },
        child: Image.network(
          "${rank[0]["Image"]}",
          width: MediaQuery.of(context).size.width,
          height: 190,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void goAction(int index) {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, "informationAccount");
          break;
        case 1:
          bookingModel.getListBookinfStatus().then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingHistory(listAction: value))));
          break;
        case 2:
          bookingModel.getListBookinfStatus().then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BeautifyHistory(listAction: value))));
          break;
        case 3:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BuyHistory()));
          break;
        // case 4:
        //   orderModel.getStatusList().then((value) => Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => MyOrder(
        //                 listTab: value,
        //               ))));
        //   break;
        case 4:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TranHistory()));
          break;
        case 5:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const QuanLiDiaChi()));
          break;
        case 6:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GioiThieuBanBe()));
          break;
        case 7:
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutUs()));
            break;
          }
        case 8:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DieuKhoanSudung()));
          break;
        case 9:
          customModal.showAlertDialog(context, "error", "Xóa tài khoản",
              "Bạn có chắc chắn muốn xóa tài khoản không?", () {
            EasyLoading.show(status: "Đang xử lý...");
            storageCustomerToken.deleteItem("customer_token");
            Future.delayed(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            });
          }, () => Navigator.of(context).pop());
          break;
        case 10:
          handleLogout();
          break;
        default:
      }
    }

    return SafeArea(
      
      bottom: false, top: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
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
              child: loading
                  ? const Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                          ]),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!Platform.isAndroid)
                    const SizedBox(
                      height: 60,
                    ),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const GiftShop()));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.4)),
                                    child: GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/icon/Xu1.png",
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            "150 xu",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Stack(children: [
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
                                                        "${profile["CustomerImage"]}"),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xff00A3FF),
                                        backgroundImage: NetworkImage(
                                            "${profile["CustomerImage"]}"),
                                        radius: 35.0,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        padding: const EdgeInsets.all(4),
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
                                              size: 10,
                                              color: Colors.blue[600],
                                            ))),
                                  )
                                ]),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(profile["CustomerName"].toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(profile["Phone"].toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500))
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  checkRank(profile["Point"]),
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: profile["MemberType"]
                                                        .toString()
                                                        .toUpperCase() ==
                                                    "SILVER"
                                                ? 42
                                                : profile["MemberType"]
                                                            .toString()
                                                            .toUpperCase() ==
                                                        "GOLD"
                                                    ? 52
                                                    : profile["MemberType"]
                                                                .toString()
                                                                .toUpperCase() ==
                                                            "PLATINUM"
                                                        ? 41
                                                        : 22,
                                            vertical: 20),
                                        child: Text(
                                          profile["CustomerName"]
                                              .toString()
                                              .toUpperCase(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      )),
                                ],
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8))),
                                                  child: Image.asset(
                                                    element["icon"],
                                                    width: 24,
                                                    height: 24,
                                                  )),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    95,
                                                child: Text(
                                                  "${element["title"]}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              )
                                            ],
                                          ),
                                          if (index < menu.length - 1)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 55, top: 5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80,
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              height: 1,
                                            )
                                        ],
                                      )),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )))),
    );
  }
}
