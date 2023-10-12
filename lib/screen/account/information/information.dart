import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/account/information/child/button_confirm.dart';
import 'package:ngoc_huong/screen/account/information/child/field_address.dart';
import 'package:ngoc_huong/screen/account/information/child/field_birthDay.dart';
import 'package:ngoc_huong/screen/account/information/child/field_email.dart';
import 'package:ngoc_huong/screen/account/information/child/field_gender.dart';
import 'package:ngoc_huong/screen/account/information/child/field_name.dart';
import 'package:ngoc_huong/screen/account/information/child/field_phone.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

class InfomationAccount extends StatefulWidget {
  const InfomationAccount({super.key});

  @override
  State<InfomationAccount> createState() => _InfomationAccountState();
}

String name = "";
DateTime? birthDay;
String email = "";
String address = "";

List genderList = [
  {
    "title": "Nam",
    "icon": "assets/images/nam-black.png",
    "iconActive": "assets/images/nam-white.png"
  },
  {
    "title": "Nữ",
    "icon": "assets/images/nu-black.png",
    "iconActive": "assets/images/nu-white.png"
  }
];
int genderValue = 0;
bool loading = true;

class _InfomationAccountState extends State<InfomationAccount> {
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  final ProfileModel profileModel = ProfileModel();
  final CustomModal customModal = CustomModal();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  void initState() {
    // storage.deleteItem("userInfo");
    super.initState();
    profileModel.getProfile().then((value) => setState(() {
          nameController = TextEditingController(text: value["CustomerName"]);
          phoneController = TextEditingController(text: value["Phone"]);
          birthDay = DateTime.parse(value["Birthday"]);
          emailController = TextEditingController(text: value["Email"]);
          addressController = TextEditingController(text: value["Address"]);
          genderValue = value["Gender"] == true ? 1 : 0;
        }));
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    loading = true;
    super.dispose();
  }

  void changeGender(int index) {
    setState(() {
      genderValue = index;
    });
  }

  void changeName(String value) {
    setState(() {
      name = value;
    });
  }

  void selectBirthDay(BuildContext context) async {
    DateTime now = DateTime.now();
    DatePickerBdaya.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 3, 5),
        maxTime: DateTime(2008, now.month, now.day),
        theme: const DatePickerThemeBdaya(
          itemStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          doneStyle: TextStyle(fontSize: 14),
        ), onChanged: (date) {
      debugPrint('change $date in time zone ${date.timeZoneOffset.inHours}');
    }, onConfirm: (date) {
      setState(() {
        birthDay = date;
      });
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }

  void changeEmail(String value) {
    setState(() {
      email = value;
    });
  }

  void changeAddress(String value) {
    setState(() {
      address = value;
    });
  }

  void saveUserInfo() async {
    final isValid = _formKey.currentState!.validate();
    FocusManager.instance.primaryFocus!.unfocus();
    Map data = {
      "CustomerName": name.isEmpty ? nameController.text : name,
      "Birthday": DateFormat("yyyy-MM-dd").format(birthDay ?? DateTime.now()),
      "Gender": genderValue,
      "Address": address.isEmpty ? addressController.text : address,
      "Email": email.isEmpty ? emailController.text : email,
      "Phone": phoneController.text,
    };
    if (!isValid) {
      return;
    } else {
      customModal.showAlertDialog(context, "error", "Lưu thông tin",
          "Bạn có chắc chắn lưu lưu thông tin?", () {
        Navigator.pop(context);
        EasyLoading.show(status: "Vui lòng chờ...");
        Future.delayed(const Duration(seconds: 2), () {
          profileModel.setProfile(data).then((value) {
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
                  'Cập nhập thông tin thành công',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                onDismiss: () {},
              ).show(context);
            });
          });
        });
      }, () => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Builder(
            builder: (context) => SafeArea(
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
                      title: const Text("Thông tin tài khoản",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                    body: !loading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    fieldName(
                                        context,
                                        (name) => changeName(name),
                                        nameController),
                                    fieldPhone(
                                        context,
                                        (name) => changeName(name),
                                        phoneController),
                                    gender(
                                        context,
                                        (index) => changeGender(index),
                                        genderValue,
                                        genderList),
                                    fieldBirthDay(
                                        context,
                                        (context) => selectBirthDay(context),
                                        birthDay),
                                    fieldEmail(
                                        context,
                                        (value) => changeEmail(value),
                                        emailController),
                                    fieldAddress(
                                        context,
                                        (value) => changeAddress(value),
                                        addressController)
                                  ],
                                ),
                              ),
                              buttonConfirm(context, saveUserInfo)
                            ],
                          )
                        : const Center(
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
                          ),
                  ),
                )));
  }
}

Widget modalChinhSach(BuildContext context) {
  String desc =
      "<p>Một số thông tin không thể thay đổi để đảm bảo chính sách khách hàng. Vui lòng liên hệ Tổng đài <a href='tel:1900123456'>1900123456</a> để được hổ trợ</p>";
  // void makingPhoneCall() async {
  //   var url = Uri.parse("tel:1900123456");
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Text("Chính sách thông tin"),
            Html(
              data: desc,
              style: {
                "*": Style(margin: Margins.only(left: 0)),
                "a": Style(textDecoration: TextDecoration.none),
                "p": Style(
                    lineHeight: const LineHeight(1.2),
                    fontSize: FontSize(15),
                    fontWeight: FontWeight.w400),
              },
              onLinkTap: (url, context, attributes, element) {
                if (url!.contains("tel:")) {}
              },
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 10),
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)))),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 15))),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Đồng ý",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    ),
  );
}
