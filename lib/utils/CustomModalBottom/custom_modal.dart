import 'package:flutter/material.dart';

class CustomModal {
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
            height: 300,
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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blue[900])),
                            onPressed: () => okFuc(),
                            child: const Text(
                              "Đồng ý",
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () => cancleFuc(),
                            child: const Text(
                              "Hủy bỏ",
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
}
