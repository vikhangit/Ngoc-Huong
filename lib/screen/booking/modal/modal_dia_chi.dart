import 'package:flutter/material.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalDiaChi extends StatefulWidget {
  final Function saveCN;
  const ModalDiaChi({super.key, required this.saveCN});

  @override
  State<ModalDiaChi> createState() => _ModalDiaChiState();
}

Map activeCN = {};

class _ModalDiaChiState extends State<ModalDiaChi> {
  void chooseDiaChi(Map item) {
    setState(() {
      activeCN = item;
    });
  }

  Future<void> launchInBrowser(String link) async {
    Uri url = Uri.parse(link);

    print("Link : " + link);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))))),
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
                      height: MediaQuery.of(context).size.height * .8 - 130,
                      child: ListView.builder(
                        itemCount: listChiNhanh.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                chooseDiaChi(listChiNhanh[index]);
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 0))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${listChiNhanh[index]["ten_kho"]}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: TextButton(
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all(
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 0)),
                                                shape: MaterialStateProperty.all(
                                                    const ContinuousRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        side: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.blue)))),
                                            onPressed: () {
                                              launchInBrowser(
                                                  "https://www.google.com/maps/search/${"Thẩm+Mỹ+Viện+Ngọc+Hường+${listChiNhanh[index]["ten_kho"] == "An Giang" || listChiNhanh[index]["ten_kho"] == "Bình Dương" ? listChiNhanh[index]["exfields"]["dia_chi"].toString().replaceAll(" ", "+") : listChiNhanh[index]["ten_kho"].toString().replaceAll(" ", "+")}"}/@${listChiNhanh[index]["location"]["latitude"]},${listChiNhanh[index]["location"]["longitude"]}");
                                            },
                                            child: const Text(
                                              "Xem vị trí",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blue),
                                            )),
                                      )
                                    ],
                                  ),
                                  if (activeCN["ma_kho"] ==
                                      listChiNhanh[index]["ma_kho"])
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
          activeCN.isNotEmpty
              ? Container(
                  height: 50,
                  margin: const EdgeInsets.all(15.0),
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)))),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20))),
                    onPressed: () {
                      widget.saveCN();
                      Navigator.pop(context);
                    },
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
                            width: 20,
                            height: 25,
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 50,
                  margin: const EdgeInsets.all(15.0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.grey[400]!),
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
                          width: 20,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
