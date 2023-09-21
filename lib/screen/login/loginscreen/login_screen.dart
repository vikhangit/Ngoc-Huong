
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/loginModel.dart';
import 'package:ngoc_huong/screen/login/login_modal/modal_otp.dart';
import 'package:ngoc_huong/screen/login/loginscreen/child/banner.dart';
import 'package:ngoc_huong/screen/login/loginscreen/child/buttom_login.dart';
import 'package:ngoc_huong/screen/login/loginscreen/child/intro.dart';
import 'package:ngoc_huong/screen/login/loginscreen/child/phone_field.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool _loading = false;
bool error = false;
String phone = "";

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DataCustom customTheme = DataCustom();
  final Login login = Login();
  LocalStorage storageAuth = LocalStorage("auth");
  void changePhone(String value) {
    setState(() {
      if (value.indexOf("0") == 0) {
        phone = value;
      } else {
        phone = "0$value";
      }
    });
  }

  void _onSubmit() async {
    FocusManager.instance.primaryFocus!.unfocus();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      await EasyLoading.show(
          status: 'Vui lòng chờ...',
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: false);
      login.getOtp(phone).then((value) {
        EasyLoading.dismiss();
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
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                height: MediaQuery.of(context).size.height * 0.88,
                child: ModalOTP(phone: phone),
              );
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(phone);
    return Form(
        key: _formKey,
        child: Builder(
            builder: (BuildContext context) => SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    resizeToAvoidBottomInset: true,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ListView(children: [
                          bannerLogin(context),
                          introLogin(context),
                          phoneField((value) => changePhone(value)),
                        ])),
                        loginButton(context, _onSubmit, _loading)
                      ],
                    ),
                  ),
                )));
  }
}
