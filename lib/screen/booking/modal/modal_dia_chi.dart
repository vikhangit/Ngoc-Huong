import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalDiaChi extends StatelessWidget {
  final Function(int index, String maKho) chooseDiaChi;
  final int active;
  const ModalDiaChi(
      {super.key, required this.chooseDiaChi, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 50,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Chọn chi nhánh",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 25,
                  height: 25,
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
                      )),
                )
              ],
            ),
          ),
          FutureBuilder(
            future: callChiNhanhApi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List listChiNhanh = snapshot.data!;
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .8 - 50,
                  child: ListView.builder(
                    itemCount: listChiNhanh.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            chooseDiaChi(index, listChiNhanh[index]["ma_kho"]);
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${listChiNhanh[index]["ten_kho"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              if (active == index)
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 20,
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
