import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/makeCallPhone.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomModal {
  final LocalStorage storageCustomer = LocalStorage('customer_token');
  void showAlertDialog(BuildContext context, String type, String title,
      String desc, Function okFuc, Function cancleFuc) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
            height: 310,
            margin: const EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox.expand(
                child: Column(
              children: [
                Icon(Icons.info_rounded,
                    size: 75,
                    color: type == "error"
                        ? Colors.red
                        : type == "wranning"
                            ? Colors.amber
                            : Colors.green),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blue[900])),
                            onPressed: () => okFuc(),
                            child: const Text(
                              "Đồng ý",
                              style: TextStyle(color: Colors.white),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 0.5, color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))))),
                            onPressed: () => cancleFuc(),
                            child: Text(
                              "Hủy bỏ",
                              style: TextStyle(color: mainColor),
                            )))
                  ],
                )
              ],
            )),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  void showBottomToolDialog(BuildContext context) {
    Future<void> launchInBrowser(String link) async {
      Uri url = Uri.parse(link);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Container(
          alignment: Alignment.bottomCenter,
          // color: Colors.black.withOpacity(0.3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
            height: 320,
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 4),
            decoration: BoxDecoration(
              //color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox.expand(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          makingPhoneCall();
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(0.0)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(9999))))),
                        child: Column(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              margin: const EdgeInsets.only(bottom: 5),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Image.asset(
                                "assets/images/call-solid-red.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                            const Text(
                              "Hotline",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        )),
                    const SizedBox(
                      width: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          if (storageCustomer.getItem("customer_token") !=
                              null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BookingServices()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const LoginScreen())));
                          }
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(0.0)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(9999))))),
                        child: Column(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              margin: const EdgeInsets.only(bottom: 5),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Image.asset(
                                "assets/images/calendar-solid-red.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                            const Text(
                              "Đặt lịch",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          EasyLoading.show(status: "Vui lòng chờ...");
                          Future.delayed(const Duration(seconds: 2), () {
                            launchInBrowser(
                                    'https://www.messenger.com/t/1505522193097958')
                                .then((value) => EasyLoading.dismiss());
                          });
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(0.0)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(9999))))),
                        child: Column(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              margin: const EdgeInsets.only(bottom: 5),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Image.asset(
                                "assets/images/messenger-red.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                            const Text(
                              "Messenger",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          launchInBrowser(
                              "https://zalo.me/1153947579240797013?gidzl=bSlKCNNPH6IHrzKqVy55OvtMqJPaanLfqO7KDZR5HsFItDHcPvb6OuEErM5Zpq8tXudQOsFN8A1cSzD3Rm");
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(0.0)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(9999))))),
                        child: Column(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              margin: const EdgeInsets.only(bottom: 5),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Image.asset(
                                "assets/images/zalo1.png",
                                height: 40,
                                width: 40,
                              ),
                            ),
                            const Text(
                              "Zalo",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  width: 65,
                  height: 65,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0.0)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(9999))))),
                      child: Image.asset(
                        "assets/images/x.png",
                        height: 40,
                        width: 40,
                      )),
                )
              ],
            )),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
}
