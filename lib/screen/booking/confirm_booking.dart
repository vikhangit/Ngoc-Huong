import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/booking_success.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ConfirmBooking extends StatefulWidget {
  final String serviceName;
  final String chinhanhName;
  final String maKho;
  final String diaChiCuThe;
  final String time;
  final String day;
  final String month;
  final String year;
  const ConfirmBooking(
      {super.key,
      required this.serviceName,
      required this.chinhanhName,
      required this.maKho,
      required this.diaChiCuThe,
      required this.time,
      required this.day,
      required this.month,
      required this.year});

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

String ten_kh = "";

class _ConfirmBookingState extends State<ConfirmBooking> {
  LocalStorage storage = LocalStorage('auth');
  @override
  void initState() {
    getProfile(storage.getItem("phone"))
        .then((value) => setState(() => ten_kh = value[0]["ma_kh"]));
    super.initState();
  }

  void addBooking() {
    Map data = {
      "ma_kh": ten_kh,
      "ten_vt": widget.serviceName,
      "time_book": widget.time,
      "date_book": "${widget.year}-${widget.month}-${widget.day}",
      "ngay": int.parse(widget.day),
      "thang": int.parse(widget.month),
      "nam": int.parse(widget.year),
      "chi_nhanh": widget.maKho,
      "trang_thai": 1,
      "dien_giai": "Đang chờ",
    };
    print(data);
    postBooking(data);
  }

  @override
  Widget build(BuildContext context) {
    String serviceName = widget.serviceName;
    String chinhanhName = widget.chinhanhName;
    String diaChiCuThe = widget.diaChiCuThe;
    String time = widget.time;
    String date = "${widget.day}/${widget.month}/${widget.year}";
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
        addBooking();
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BookingSuccess())); //pop dialog
      });
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 5,
            // ),
            appBar: AppBar(
                bottomOpacity: 0.0,
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
                title: const Text("Kiểm tra thông tin",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black))),
            drawer: const MyLeftMenu(),
            body: Column(
                // reverse: true,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        const Text(
                          "Xác nhận thông tin",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Thông tin khách hàng",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(children: [
                                    Image.asset(
                                      "assets/images/icon/profile-red.png",
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    FutureBuilder(
                                      future:
                                          getProfile(storage.getItem("phone")),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data![0]["ten_kh"]}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          );
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    )
                                  ]),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(children: [
                                    Image.asset(
                                      "assets/images/call-solid-red.png",
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    FutureBuilder(
                                      future:
                                          getProfile(storage.getItem("phone")),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data![0]["of_user"]}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          );
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    )
                                  ]),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Chi nhánh",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/images/location-solid-red.png",
                                          width: 22,
                                          height: 22,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Chi nhánh $chinhanhName",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "$diaChiCuThe, $chinhanhName",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        ))
                                      ]),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Thời gian",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(children: [
                                    Image.asset(
                                      "assets/images/time-solid-red.png",
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "$time $date",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ]),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Dịch vụ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(children: [
                                    Image.asset(
                                      "assets/images/note-solid-red.png",
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Text(
                                      serviceName.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    )),
                                  ]),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                            // if (widget.dienGiai.isNotEmpty)
                            //   Container(
                            //     padding: const EdgeInsets.all(16),
                            //     margin: const EdgeInsets.only(top: 20),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: const BorderRadius.all(
                            //           Radius.circular(10)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.5),
                            //           spreadRadius: 1,
                            //           blurRadius: 8,
                            //           offset: const Offset(
                            //               4, 4), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         const Text(
                            //           "Ghi chú",
                            //           style: TextStyle(
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w400),
                            //         ),
                            //         const SizedBox(
                            //           height: 15,
                            //         ),
                            //         Row(children: [
                            //           Image.asset(
                            //             "assets/images/note-solid-red.png",
                            //             width: 22,
                            //             height: 22,
                            //             fit: BoxFit.contain,
                            //           ),
                            //           const SizedBox(
                            //             width: 8,
                            //           ),
                            //           Expanded(
                            //               child: Text(
                            //             widget.dienGiai.toString(),
                            //             style: const TextStyle(
                            //                 fontSize: 14,
                            //                 color: Colors.black,
                            //                 fontWeight: FontWeight.w300),
                            //           )),
                            //         ]),
                            //         const SizedBox(
                            //           height: 6,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        left: 15,
                        right: 15),
                    child: TextButton(
                        onPressed: () {
                          onLoading();
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)))),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 20))),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            const Expanded(
                              flex: 8,
                              child: Center(
                                child: Text(
                                  "Xác nhận",
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
                                width: 25,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        )),
                  )
                ])));
  }
}
