import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:ngoc_huong/utils/validate.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:url_launcher/url_launcher.dart';

class InfomationAccount extends StatefulWidget {
  const InfomationAccount({super.key});

  @override
  State<InfomationAccount> createState() => _InfomationAccountState();
}

int ngay = 0;
int thang = 0;
int nam = 0;
List<String> items = ['Chọn giới tính', 'Nam', 'Nữ'];
String gender = items[0];
bool isLoading = true;
String id = "";

class _InfomationAccountState extends State<InfomationAccount> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  LocalStorage storage = LocalStorage("auth");
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      getProfile(storage.getItem("phone")).then((value) => setState(() {
            id = value[0]["_id"];
            nameController = TextEditingController(text: value[0]["ten_kh"]);
            phoneController = TextEditingController(text: value[0]["of_user"]);
            emailController =
                TextEditingController(text: value[0]["email"] ?? "");
            gender = value[0]["gioi_tinh"] != null
                ? items.indexOf(value[0]["gioi_tinh"]) > 0
                    ? items[items.indexOf(value[0]["gioi_tinh"])]
                    : items[0]
                : items[0];
            birthdayController = TextEditingController(
                text: value[0]["ngay_sinh"] != null
                    ? DateFormat("dd/MM/yyyy").format(
                        DateTime.parse(value[0]["ngay_sinh"].toString()))
                    : "");
            ngay = int.parse(DateFormat("dd").format(DateTime.parse(
                value[0]["ngay_sinh"] == null
                    ? DateTime.now().toString()
                    : value[0]["ngay_sinh"].toString())));
            thang = int.parse(DateFormat("MM").format(DateTime.parse(
                value[0]["ngay_sinh"] == null
                    ? DateTime.now().toString()
                    : value[0]["ngay_sinh"].toString())));
            nam = int.parse(DateFormat("yyyy").format(DateTime.parse(
                value[0]["ngay_sinh"] == null
                    ? DateTime.now().toString()
                    : value[0]["ngay_sinh"].toString())));
            isLoading = false;
          }));
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    genderController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void selectBirthDay(BuildContext context) async {
      DatePickerBdaya.showDatePicker(context,
          showTitleActions: true,
          minTime: DateTime(1900, 3, 5),
          maxTime: DateTime(3000, 12, 31),
          theme: const DatePickerThemeBdaya(
            itemStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
            doneStyle: TextStyle(fontSize: 14),
          ), onChanged: (date) {
        debugPrint('change $date in time zone ${date.timeZoneOffset.inHours}');
      }, onConfirm: (date) {
        setState(() {
          birthdayController = TextEditingController(
              text: DateFormat("dd/MM/yyyy").format(date));
          nam = int.parse(
              DateFormat("yyyy").format(DateTime.parse(date.toString())));
          thang = int.parse(
              DateFormat("MM").format(DateTime.parse(date.toString())));
          ngay = int.parse(
              DateFormat("dd").format(DateTime.parse(date.toString())));
        });
      }, currentTime: DateTime(nam, thang, ngay), locale: LocaleType.vi);
    }

    void changeProfile() async {
      Map data = {
        "ngay_sinh": birthdayController.text.isNotEmpty
            ? "${nam.toString()}-${thang < 10 ? "0$thang" : thang}-${ngay < 10 ? "0$ngay" : ngay}T07:00:32.534Z"
            : "",
        "gioi_tinh": items.indexOf(gender) > 0 ? gender : "",
        "email": emailController.text.isNotEmpty ? emailController.text : "",
        "ten_kh": nameController.text.isNotEmpty ? nameController.text : "",
        "dien_thoai": phoneController.text,
        "sdt_lien_he": phoneController.text
      };
      await updateProfile(id, storage.getItem("phone"), data).then((value) {
        Navigator.pushNamed(context, "account");
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
      Future.delayed(const Duration(seconds: 3), () {
        changeProfile();
        setState(() {
          isLoading = true;
        });
        Navigator.pop(context);
      });
    }

    void showInfoDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Lưu lại thông tin",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Bạn có muốn lưu lại thông tin khônng?",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    )
                  ],
                ));
          },
        ),
        actionsPadding:
            const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () => onLoading(),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 15)),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary)),
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
                    const EdgeInsets.symmetric(vertical: 15)),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    side: BorderSide(color: Colors.grey, width: 1))),
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
    print(birthdayController.text);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 3,
            // ),
            appBar: AppBar(
              bottomOpacity: 0.0,
              elevation: 0.0,
              leadingWidth: 40,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.west,
                  size: 24,
                  color: Colors.black,
                ),
              ),
              title: const Text("Thông tin tài khoản",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              actions: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: modalChinhSach(context),
                          );
                        });
                  },
                  child: const Icon(
                    Icons.info_outline_rounded,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 12,
                )
              ],
            ),
            drawer: const MyLeftMenu(),
            body: isLoading == true
                ? const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Loading"),
                      ],
                    ),
                  )
                : Column(
                    // reverse: true,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 7),
                                    child: const Text(
                                      "Họ Tên",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                  TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập tên';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      focusedBorder: border,
                                      errorBorder: border,
                                      focusedErrorBorder: border,
                                      enabledBorder: border2,
                                      contentPadding: const EdgeInsets.only(
                                          left: 5,
                                          right: 15,
                                          top: 18,
                                          bottom: 18),
                                      prefix: const Padding(
                                          padding: EdgeInsets.only(left: 15.0)),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 7),
                                    child: const Text(
                                      "Số điện thoại",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                  TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng số điện thoại';
                                      } else if (!value.isValidPhone) {
                                        return 'Số điện thoại không đúng định dạng';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      focusedBorder: border,
                                      errorBorder: border,
                                      focusedErrorBorder: border,
                                      enabledBorder: border2,
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      contentPadding: const EdgeInsets.only(
                                          left: 5,
                                          right: 15,
                                          top: 18,
                                          bottom: 18),
                                      prefix: const Padding(
                                          padding: EdgeInsets.only(left: 15.0)),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 7),
                                    child: const Text(
                                      "Giới tính",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                  TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      focusedBorder: border,
                                      errorBorder: border,
                                      focusedErrorBorder: border,
                                      enabledBorder: border2,
                                      suffixIcon: DropdownButtonFormField(
                                        value: gender,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        onChanged: (newValue) {
                                          setState(() {
                                            gender = newValue!;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white))),
                                        items: items
                                            .map<DropdownMenuItem<String>>(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 7),
                                    child: const Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                  TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập email';
                                      } else if (!value.isValidEmail) {
                                        return 'Email không đúng định dàng';
                                      }
                                      return null;
                                    },
                                    controller: emailController,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      focusedBorder: border,
                                      errorBorder: border,
                                      focusedErrorBorder: border,
                                      enabledBorder: border2,
                                      contentPadding: const EdgeInsets.only(
                                          left: 5,
                                          right: 15,
                                          top: 18,
                                          bottom: 18),
                                      prefix: const Padding(
                                          padding: EdgeInsets.only(left: 15.0)),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w400),
                                      hintText: 'Nhập email',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 7),
                                    child: const Text(
                                      "Ngày sinh",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                  TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: birthdayController,
                                    readOnly: true,
                                    onTap: () => selectBirthDay(context),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      suffixIcon: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Image.asset(
                                          "assets/images/calendar-black.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary), //<-- SEE HERE
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.grey), //<-- SEE HERE
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 18),
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(0.3),
                                          fontWeight: FontWeight.w400),
                                      hintText: 'Nhập ngày sinh',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: TextButton(
                          onPressed: () {
                            showInfoDialog(context);
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)))),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 20))),
                          child: const Center(
                            child: Text(
                              "Lưư thông tin",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )));
  }
}

Widget modalChinhSach(BuildContext context) {
  String desc =
      "<p>Một số thông tin không thể thay đổi để đảm bảo chính sách khách hàng. Vui lòng liên hệ Tổng đài <a href='tel:1900123456'>1900123456</a> để được hổ trợ</p>";
  void makingPhoneCall() async {
    var url = Uri.parse("tel:1900123456");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                if (url == "tel:1900123456") {
                  makingPhoneCall();
                }
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
