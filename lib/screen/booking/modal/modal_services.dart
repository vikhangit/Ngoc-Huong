import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/booking/booking_step2.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalService extends StatefulWidget {
  final String id;
  final String title;
  final String maKho;
  const ModalService(
      {super.key, required this.id, required this.title, required this.maKho});

  @override
  State<ModalService> createState() => _ModalServiceState();
}

String activeId = "";
String activeTitle = "";
String activeMaKho = "";

class _ModalServiceState extends State<ModalService> {
  void chooseFuction(String id, String title) {
    setState(() {
      activeId = id;
      activeTitle = title;
    });
  }

  @override
  void dispose() {
    activeId = "";
    activeTitle = "";
    super.dispose();
  }

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
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    String activeMaKho = widget.maKho;
    return SizedBox(
      child: Column(
        children: [
          Container(
            height: 50,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dịch vụ ${title.toLowerCase()}",
                  style: const TextStyle(fontSize: 16),
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
            future: callServiceApi(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List list = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .8 - 115,
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                chooseFuction(
                                    list[index]["_id"], list[index]["ten_vt"]);
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 0))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${list[index]["ten_vt"]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  if (activeId == list[index]["_id"])
                                    const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.green,
                                    )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
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
                          if (activeId.isEmpty) {
                            showAlertDialog(context,
                                "Vui lòng chọn chi nhánh và dịch vụ muốn đặt");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookingStep2(
                                          choose: choose,
                                          serviceName: activeTitle,
                                          maKho: activeMaKho,
                                        )));
                          }
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
                  ],
                );
              } else {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
