import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/booking/booking_step2.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalDiaChiBooking extends StatefulWidget {
  final String activeService;
  const ModalDiaChiBooking({super.key, required this.activeService});

  @override
  State<ModalDiaChiBooking> createState() => _ModalDiaChiBookingState();
}

Map CN = {};

class _ModalDiaChiBookingState extends State<ModalDiaChiBooking> {
  void chooseDiaChi(Map item) {
    setState(() {
      CN = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    String activeServie = widget.activeService;
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
                    List list = snapshot.data!.toList();
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .8 - 130,
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                chooseDiaChi(list[index]);
                                // Navigator.pop(context);
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
                                        "${list[index]["ten_kho"]}",
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
                                            onPressed: () {},
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
                                  if (CN["ma_kho"] == list[index]["ma_kho"])
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
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
          CN.isNotEmpty
              ? Container(
                  height: 50,
                  margin: const EdgeInsets.all(15.0),
                  child: TextButton(
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingStep2(
                                  serviceName: activeServie, activeCN: CN)));
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            "assets/images/calendar-white.png",
                            width: 24,
                            height: 24,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
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
