import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_otp.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';

class ModalPassExist extends StatefulWidget {
  const ModalPassExist({super.key});

  @override
  State<ModalPassExist> createState() => _ModalPassExistState();
}

String password = "";
bool showPass = false;
bool err = false;

class _ModalPassExistState extends State<ModalPassExist> {
  final LocalStorage storage = LocalStorage('auth');
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
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    setState(() {
      password = "";
      showPass = false;
      err = false;
    });
    super.initState();
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
                  const Text("Nhập mật khẩu",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
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
                    autofocus: true,
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
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        storage.setItem("typeOTP", "forgot");
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
                                child:
                                    ModalOTP(phone: storage.getItem("phone")),
                              );
                            });
                      },
                      child: const Text(
                        "Quên mật khẩu",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        storage.deleteItem("typeOTP");
                        showModalBottomSheet<void>(
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
                                    MediaQuery.of(context).size.height * 0.96,
                                child: const ModalPhone(),
                              );
                            });
                      },
                      child: const Text(
                        "Đăng nhập bằng số điện thoại khác",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  password.length >= 6
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0))),
                          child: TextButton(
                              onPressed: () {
                                if (storage.getItem("pass") != password) {
                                  showAlertDialog(context,
                                      "Mật khẩu không đúng. Xin hãy thử lại");
                                } else {
                                  storage.setItem("authen", "true");
                                  Navigator.pushNamed(context, "home");
                                }
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(0.0))),
                              child: const Text("Tiếp tục",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white))),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0))),
                          child: const Text("Tiếp tục",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                        )
                ],
              ),
            ]));
  }
}

Widget intro(
  BuildContext context,
) {
  final LocalStorage storage = LocalStorage('auth');
  var user = storage.getItem("lastname") ?? "";
  var phoneNum = storage.getItem("phone");
  return Container(
    margin: const EdgeInsets.only(bottom: 50),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close),
            ),
          ),
          Text(
            "Xin chào, $user",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            phoneNum.toString(),
          ),
        ]),
  );
}
