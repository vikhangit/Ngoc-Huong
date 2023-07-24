import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/signup_success.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalPass extends StatefulWidget {
  final String phone;
  const ModalPass({super.key, required this.phone});

  @override
  State<ModalPass> createState() => _ModalPassState();
}

String fName = "";
String lName = "";
String password = "";
String confirmPassword = "";
bool showPass = false;
bool showConfirm = false;
bool check = true;

class _ModalPassState extends State<ModalPass> {
  LocalStorage storage = LocalStorage('auth');
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

  @override
  void dispose() {
    password = "";
    confirmPassword = "";
    showPass = false;
    showConfirm = false;
    check = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addUser() async {
      Map data = {
        "email": widget.phone,
        "name": "$fName $lName",
        "password": password,
        "rePassword": confirmPassword,
        "group_id": groupId,
        "id_app": idApp
      };
      final dio = Dio();
      try {
        final response = await dio
            .post("https://api.fostech.vn/signup", data: data)
            .then((value) {
          setState(() {
            Navigator.pop(context);
            Navigator.pushNamed(context, "home");
            ElegantNotification.success(
              width: MediaQuery.of(context).size.width,
              height: 50,
              notificationPosition: NotificationPosition.topCenter,
              toastDuration: const Duration(milliseconds: 2000),
              animation: AnimationType.fromTop,
              // title: const Text('Cập nhật'),
              description: const Text(
                'Đăng ký tài khoản thành công',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              onDismiss: () {},
            ).show(context);
          });
        });
      } on DioException catch (e) {
        showAlertDialog(context, "${e.response!.data["error"]}");
      }
    }

    void saveUserInfo() {
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
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        addUser();
        Navigator.pop(context);
      });
    }

    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    intro(context, storage),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 48,
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text("Họ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300)),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text("*",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w300)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  autofocus: true,
                                  onChanged: (value) {
                                    fName = value;
                                  },
                                  decoration: InputDecoration(
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.grey), //<-- SEE HERE
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 18),
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.3),
                                        fontWeight: FontWeight.w300),
                                    hintText: 'Họ của bạn...',
                                  ),
                                ),
                              ],
                            )),
                        Expanded(flex: 4, child: Container()),
                        Expanded(
                            flex: 48,
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text("Tên",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300)),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text("*",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w300)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  onChanged: (value) {
                                    setState(() {
                                      lName = value;
                                    });
                                  },
                                  decoration: InputDecoration(
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.grey), //<-- SEE HERE
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 18),
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.3),
                                        fontWeight: FontWeight.w300),
                                    hintText: 'Tên của bạn...',
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        storage.getItem("typeOTP") == null
                            ? "Tạo mật khẩu"
                            : "Mật khẩu mới",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      // keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      onChanged: (value) {
                        setState(() {
                          password = value.toString();
                        });
                      },
                      obscureText: !showPass,
                      enableSuggestions: false,
                      autocorrect: false,

                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          icon: showPass == false
                              ? const Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                        ),
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 18),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary), //<-- SEE HERE
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              width: 1, color: Colors.grey), //<-- SEE HERE
                        ),
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.3),
                            fontWeight: FontWeight.w400),
                        hintText: '••••••',
                      ),
                    ),
                    if (password.isNotEmpty && password.length < 6)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text("Mật khẩu cần ít nhất 6 số",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w300)),
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text("Xác nhận mật khẩu",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      // keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value.toString();
                        });
                      },
                      obscureText: !showConfirm,
                      enableSuggestions: false,
                      autocorrect: false,

                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showConfirm = !showConfirm;
                              });
                            },
                            icon: showConfirm == false
                                ? const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  ),
                          ),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 18),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary), //<-- SEE HERE
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey), //<-- SEE HERE
                          ),
                          hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.3),
                              fontWeight: FontWeight.w400),
                          hintText: '••••••'),
                    ),
                    if (confirmPassword.length >= 6 &&
                        confirmPassword != password)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text("Xác nhận mật khẩu không đúng",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w300)),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (storage.getItem("typeOTP") == null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                color: check ? Colors.green : Colors.white,
                                border: Border.all(
                                    width: 1,
                                    color: check ? Colors.green : Colors.black),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    check = !check;
                                  });
                                },
                                child: check == true
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : null),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Bằng việc tiếp tục, bạn xác nhận đã đọc và",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black.withOpacity(0.7))),
                              Row(
                                children: [
                                  Text("đồng ý với",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Text("Điều khoản và sử dụng",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500)),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      )
                  ],
                ),
              ),
              password.length >= 6 &&
                      confirmPassword.length >= 6 &&
                      password == confirmPassword &&
                      check == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: TextButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            saveUserInfo();
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0.0))),
                          child: Text(
                              storage.getItem("typeOTP") == null
                                  ? "Xác nhận"
                                  : "Hoàn thành",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white))),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Text(
                          storage.getItem("typeOTP") == null
                              ? "Tiếp tục"
                              : "Hoàn thành",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black)),
                    )
            ]));
  }
}

Widget intro(
  BuildContext context,
  LocalStorage storage,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            storage.getItem("typeOTP") == null
                ? "Mật khẩu đăng nhập"
                : "Khôi phục mật khẩu",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: storage.getItem("typeOTP") == null ? 10 : 30,
          ),
          if (storage.getItem("typeOTP") == null)
            const Text("Mật khẩu giúp tài khoản của bạn bảo mật và an toàn hơn",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300))
        ]),
  );
}
