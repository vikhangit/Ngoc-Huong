import 'package:flutter/material.dart';

class ModalPayment extends StatefulWidget {
  final Function() savePayment;
  const ModalPayment({super.key, required this.savePayment});

  @override
  State<ModalPayment> createState() => _ModalVoucherState();
}

String activePayment = "Thanh toán khi nhận hàng";

List paymentMethod = [
  {"icon": "assets/images/thanh-toan.png", "title": "Thẻ Tín dụng/Ghi nợ"},
  {"icon": "assets/images/cod.png", "title": "Thanh toán khi nhận hàng"},
  {
    "icon": "assets/images/chuyen-khoan.png",
    "title": "Chuyển đến thẻ ngân hàng"
  },
];

class _ModalVoucherState extends State<ModalPayment> {
  @override
  void initState() {
    setState(() {
      activePayment = "Thanh toán khi nhận hàng";
    });
    super.initState();
  }

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

    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Phương thức thanh toán",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 25,
                        height: 20,
                        child: TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(0))),
                            onPressed: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.black,
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: MediaQuery.of(context).size.height * 0.6 - 140,
                    child: ListView(
                        children: paymentMethod.map((item) {
                      return TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 15))),
                          onPressed: () {
                            if (item["title"] == "Thẻ Tín dụng/Ghi nợ" ||
                                item["title"] == "Chuyển đến thẻ ngân hàng") {
                              showAlertDialog(context,
                                  "Xin lỗi quý khách chúng tôi đang nâng cấp tính nâng thanh toán này. Hiện tại chỉ có thể thanh toán khi nhận hàng. Xin lỗi vì sự bất tiện này");
                            } else {
                              setState(() {
                                activePayment = item["title"];
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    item["icon"],
                                    width: 28,
                                    height: 28,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    item["title"],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              if (activePayment == item["title"])
                                const Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.green,
                                )
                            ],
                          ));
                    }).toList()))
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(50.0))),
              child: TextButton(
                  onPressed: () {
                    widget.savePayment();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0.0))),
                  child: const Text("Xác nhận",
                      style: TextStyle(fontSize: 14, color: Colors.white))),
            )
          ],
        ));
  }
}
