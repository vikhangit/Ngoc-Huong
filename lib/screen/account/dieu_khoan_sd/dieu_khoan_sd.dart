import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class DieuKhoanSudung extends StatefulWidget {
  const DieuKhoanSudung({super.key});

  @override
  State<DieuKhoanSudung> createState() => _DieuKhoanSudungState();
}

class _DieuKhoanSudungState extends State<DieuKhoanSudung> {
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

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            // bottomOpacity: 0.0,
            primary: false,
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
            title: const Text("Điều khoản sử dụng",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
          drawer: const MyLeftMenu(),
          body: SizedBox(
            child: Expanded(
              child: ListView(
                children: [
                  TextButton(
                      onPressed: () {
                        showAlertDialog(context,
                            "Xin lỗi quý khách. Chúng tôi đang cập nhập tính năng này");
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Điều khoản sử dụng",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
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
                                  horizontal: 15, vertical: 20))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chính sách thành viên",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
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
                                  horizontal: 15, vertical: 20))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bảo mật thành viên",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
