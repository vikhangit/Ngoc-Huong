import 'package:flutter/material.dart';

class ModalVoucher extends StatefulWidget {
  const ModalVoucher({super.key});

  @override
  State<ModalVoucher> createState() => _ModalVoucherState();
}

class _ModalVoucherState extends State<ModalVoucher> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Ngọc Hường Voucher",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 80 - 25,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            onChanged: (value) {
                              setState(() {
                                // valueSearch = value;
                              });
                            },
                            // controller: controller,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary), //<-- SEE HERE
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey), //<-- SEE HERE
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              hintStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              hintText: 'Nhập mã voucher',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.grey[400]),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 15))),
                              child: const Text(
                                "Áp dụng",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              )),
                        )
                      ],
                    )),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6 - 200,
                    child: ListView(
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ưu đãi phí vận chuyển",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Có thể chọn một voucher",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                        Column(children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text("Hiện tại chưa có ưu đãi vận chuyển"),
                          SizedBox(
                            height: 40,
                          ),
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mã giảm giá/hoàn xu",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Có thể chọn một voucher",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                        Column(children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text("Hiện tại chưa có mã giảm giá"),
                          SizedBox(
                            height: 40,
                          ),
                        ]),
                      ],
                    ))
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0))),
              child: TextButton(
                  onPressed: () {
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
