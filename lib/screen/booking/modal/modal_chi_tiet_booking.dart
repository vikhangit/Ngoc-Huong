import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalChiTietBooking extends StatefulWidget {
  final Map details;
  final Map details2;
  final Function? save;
  const ModalChiTietBooking(
      {super.key, required this.details, required this.details2, this.save});

  @override
  State<ModalChiTietBooking> createState() => _ModalChiTietBookingState();
}

class _ModalChiTietBookingState extends State<ModalChiTietBooking> {
  @override
  Widget build(BuildContext context) {
    Map details = widget.details;
    Map details2 = widget.details2;
    void cancleOrder() async {
      Map data = {"dien_giai": "Chờ trả"};
      await putBooking(details["_id"], data).then((value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const BookingHistory(
                    ac: 2,
                  ))));
      widget.save!();
    }

    void onLoading() {
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
                Text("Đang xử lý"),
              ],
            ),
          ));
        },
      );
      Future.delayed(const Duration(seconds: 3), () {
        cancleOrder();
        Navigator.pop(context);
      });
    }

    void showInfoDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(
              builder: (context) {
                return SizedBox(
                    // height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info,
                          size: 70,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Hủy đặt lịch",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Bạn có chắc chắn hủy dặt lịch này không?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w300),
                        )
                      ],
                    ));
              },
            ),
            actionsPadding:
                const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    onLoading();
                    // Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15)),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary)),
                  child: const Text(
                    "Đồng ý",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 15)),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(color: Colors.grey, width: 1))),
                  ),
                  child: const Text("Hủy bỏ"),
                ),
              )
            ],
          );
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30))),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      width: 36,
                      height: 36,
                      child: const Icon(
                        Icons.west,
                        size: 16,
                        color: Colors.black,
                      ),
                    )),
              ),
              const Expanded(
                flex: 84,
                child: Center(
                  child: Text(
                    "Chi tiết dịch vụ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.95 -
              (details["dien_giai"] == "Đang chờ" ? 155 : 100),
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
        ),
        if (details["dien_giai"] == "Đang chờ")
          Container(
            margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: TextButton(
                onPressed: () {
                  showInfoDialog();
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hủy đặt lịch",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      "assets/images/calendar-white.png",
                      width: 24,
                      height: 34,
                      fit: BoxFit.contain,
                    ),
                  ],
                )),
          )
      ],
    );
  }
}
