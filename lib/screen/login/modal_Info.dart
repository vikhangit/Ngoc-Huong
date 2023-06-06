import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/InfoField/button_confirm.dart';
import 'package:ngoc_huong/screen/login/InfoField/field_birthDay.dart';
import 'package:ngoc_huong/screen/login/InfoField/field_email.dart';
import 'package:ngoc_huong/screen/login/InfoField/field_gender.dart';
import 'package:ngoc_huong/screen/login/InfoField/field_name.dart';

class ModalInfo extends StatefulWidget {
  const ModalInfo({super.key});

  @override
  State<ModalInfo> createState() => _ModalInfoState();
}

String firstname = "";
String lastname = "";
String birthDay = "";
String email = "";

List genderList = ["Nam", "Nữ", "Khác"];
String genderValue = "Nam";

class _ModalInfoState extends State<ModalInfo> {
  final LocalStorage storage = LocalStorage('auth');
  @override
  void initState() {
    setState(() {
      firstname = "";
      lastname = "";
      birthDay = "";
      email = "";
    });
    // storage.deleteItem("userInfo");
    super.initState();
  }

  void changeGender(value) {
    setState(() {
      genderValue = value;
    });
  }

  void changeFirstName(value) {
    setState(() {
      firstname = value;
    });
  }

  void changeLastName(value) {
    setState(() {
      lastname = value;
    });
  }

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
        birthDay = DateFormat("dd/MM/yyyy").format(date);
      });
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }

  void changeEmail(value) {
    setState(() {
      email = value;
    });
  }

  void saveUserInfo() async {
    // storage.deleteItem("userInfo");
    await storage.setItem("gender", genderValue);
    await storage.setItem("firstname", firstname);
    await storage.setItem("lastname", lastname);
    await storage.setItem("birthday", birthDay);
    await storage.setItem("email", email);
    await storage.setItem("authen", "true");
    storage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  intro(context),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 290
                        : 380,
                    child: Expanded(
                      child: ListView(
                        children: [
                          gender(context, (value) => changeGender(value)),
                          fieldName(context, (fName) => changeFirstName(fName),
                              (lName) => changeLastName(lName)),
                          fieldBirthDay(
                              context, (context) => selectBirthDay(context)),
                          fieldEmail(context, (value) => changeEmail(value))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              buttonConfirm(context, saveUserInfo)
            ]));
  }
}

Widget intro(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
    child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Nhập thông tin",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Ngọc Hường cam kết bảo mật thông tin cá nhân của bạn",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300))
        ]),
  );
}
