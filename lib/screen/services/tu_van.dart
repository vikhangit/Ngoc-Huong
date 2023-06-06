import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/tu_van_success.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:ngoc_huong/utils/validate.dart';

class TuVanScreen extends StatefulWidget {
  const TuVanScreen({super.key});

  @override
  State<TuVanScreen> createState() => _TuVanScreenState();
}

String name = '';
String phone = '';
String email = '';
String address = '';
String note = '';

class _TuVanScreenState extends State<TuVanScreen> {
  @override
  void dispose() {
    name = '';
    phone = '';
    email = '';
    address = '';
    note = '';
    super.dispose();
  }

  void addTuVan() async {
    Map data = {
      "ten_lien_he": name,
      "dien_thoai": phone,
      "email": email,
      "dia_chi": address,
      "ghi_chu": note
    };
    await postLienHeTuVan(data);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.primary), //<-- SEE HERE
    );
    var border2 = const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1, color: Colors.grey));
    void onLoading() {
      if (_formKey.currentState!.validate()) {
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
          addTuVan();
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TuVanSuccess())); //pop dialog
        });
      }
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 0,
            // ),
            appBar: AppBar(
              centerTitle: true,
              bottomOpacity: 0.0,
              elevation: 0.0,
              backgroundColor: Colors.white,
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
              title: const Text("Tư vấn",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            drawer: const MyLeftMenu(),
            body: Column(
              // reverse: true,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/logo2.png",
                            width: 102,
                            height: 54,
                            fit: BoxFit.cover,
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
                                  "Tên",
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
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: border,
                                  errorBorder: border,
                                  focusedErrorBorder: border,
                                  enabledBorder: border2,
                                  contentPadding: const EdgeInsets.only(
                                      left: 5, right: 15, top: 18, bottom: 18),
                                  prefix: const Padding(
                                      padding: EdgeInsets.only(left: 15.0)),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.3),
                                      fontWeight: FontWeight.w400),
                                  hintText: 'Nhập tên',
                                ),
                              ),
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
                                onChanged: (value) {
                                  setState(() {
                                    phone = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: border,
                                  errorBorder: border,
                                  focusedErrorBorder: border,
                                  enabledBorder: border2,
                                  contentPadding: const EdgeInsets.only(
                                      left: 5, right: 15, top: 18, bottom: 18),
                                  prefix: const Padding(
                                      padding: EdgeInsets.only(left: 15.0)),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.3),
                                      fontWeight: FontWeight.w400),
                                  hintText: 'Nhập số điện thoại',
                                ),
                              ),
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
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: border,
                                  errorBorder: border,
                                  focusedErrorBorder: border,
                                  enabledBorder: border2,
                                  contentPadding: const EdgeInsets.only(
                                      left: 5, right: 15, top: 18, bottom: 18),
                                  prefix: const Padding(
                                      padding: EdgeInsets.only(left: 15.0)),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.3),
                                      fontWeight: FontWeight.w400),
                                  hintText: 'Nhập email',
                                ),
                              ),
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
                                  "Địa chỉ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập địa chỉ';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                onChanged: (value) {
                                  setState(() {
                                    address = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: border,
                                  errorBorder: border,
                                  focusedErrorBorder: border,
                                  enabledBorder: border2,
                                  contentPadding: const EdgeInsets.only(
                                      left: 5, right: 15, top: 18, bottom: 18),
                                  prefix: const Padding(
                                      padding: EdgeInsets.only(left: 15.0)),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.3),
                                      fontWeight: FontWeight.w400),
                                  hintText: 'Nhập địa chỉ',
                                ),
                              ),
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
                                  "Chi tiết tư vấn",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chi tiết tư vẫn';
                                  }
                                  return null;
                                },
                                maxLines: 5,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                onChanged: (value) {
                                  setState(() {
                                    note = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: border,
                                  errorBorder: border,
                                  focusedErrorBorder: border,
                                  enabledBorder: border2,
                                  contentPadding: const EdgeInsets.only(
                                      left: 5, right: 15, top: 18, bottom: 18),
                                  prefix: const Padding(
                                      padding: EdgeInsets.only(left: 15.0)),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.3),
                                      fontWeight: FontWeight.w400),
                                  hintText:
                                      'Nhập dịch vụ hoặc mỹ phẩm bạn muốn được tư vẫn',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: TextButton(
                      onPressed: () {
                        onLoading();
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)))),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 20))),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Container()),
                          const Expanded(
                            flex: 8,
                            child: Center(
                              child: Text(
                                "Tiếp tục",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/calendar-white.png",
                                width: 25,
                                height: 30,
                                fit: BoxFit.contain,
                              ))
                        ],
                      )),
                )
              ],
            )));
  }
}
