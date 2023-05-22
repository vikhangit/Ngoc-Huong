import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/services/tu_van.dart';

class ModalChiNhanhTuVan extends StatelessWidget {
  final Function(int index) chooseChiNhanhTuVan;
  const ModalChiNhanhTuVan({super.key, required this.chooseChiNhanhTuVan});

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
          SizedBox(
            height: MediaQuery.of(context).size.height * .8 - 50,
            child: ListView.builder(
              itemCount: chiNhanhTuVan.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      chooseChiNhanhTuVan(index);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${chiNhanhTuVan[index]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                        if (activeChiNhanhTuVan == index)
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
          )
        ],
      ),
    );
  }
}
