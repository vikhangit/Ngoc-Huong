import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalChiTietBooking extends StatefulWidget {
  final Map details;
  final Map details2;
  const ModalChiTietBooking(
      {super.key, required this.details, required this.details2});

  @override
  State<ModalChiTietBooking> createState() => _ModalChiTietBookingState();
}

class _ModalChiTietBookingState extends State<ModalChiTietBooking> {
  @override
  Widget build(BuildContext context) {
    Map details = widget.details;
    Map details2 = widget.details2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            children: [
              Expanded(
                  flex: 8,
                  child: SizedBox(
                    height: 20,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.west,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  )),
              const Expanded(
                flex: 84,
                child: Center(
                  child: Text(
                    "Chi tiết lịch",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    "$apiUrl${details2["picture"]}?$token",
                    height: 210,
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        details2["ten_vt"],
                        style: const TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            NumberFormat.currency(locale: "vi_VI", symbol: "đ")
                                .format(
                              details2["gia_ban_le"],
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.orange,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: const Text("4.8"),
                              ),
                              const Text(
                                "(130 đánh giá)",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Thông tin đặt lịch",
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tháng ${details["thang"] < 10 ? "0${details["thang"]}" : details["thang"]}, ${details["nam"]}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    "${details["ngay"] < 10 ? "0${details["ngay"]}" : details["ngay"]}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 80),
                                  )
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Text(
                                          details["dien_giai"],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/time-solid-black.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        details["time_book"],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/images/location-solid-black.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      FutureBuilder(
                                        future: callChiNhanhApiByCN(
                                            "${details["chi_nhanh"]}"),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Flexible(
                                                child: Text(
                                              "${snapshot.data![0]["exfields"]["dia_chi"]}, ${snapshot.data![0]["ten_kho"]}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300),
                                            ));
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        )
      ],
    );
  }
}
