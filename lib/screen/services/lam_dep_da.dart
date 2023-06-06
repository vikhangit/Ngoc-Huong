import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/booking_step2.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:url_launcher/url_launcher.dart';

class LamDepDaScreen extends StatefulWidget {
  const LamDepDaScreen({super.key});

  @override
  State<LamDepDaScreen> createState() => _LamDepDaScreenState();
}

class _LamDepDaScreenState extends State<LamDepDaScreen> {
  _makingPhoneCall() async {
    var url = Uri.parse("tel:9776765434");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const MyBottomMenu(
              active: 0,
            ),
            appBar: AppBar(
              centerTitle: true,
              bottomOpacity: 0.0,
              elevation: 0.0,
              backgroundColor: Colors.white,
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
              title: const Text("Làm đẹp da",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            drawer: const MyLeftMenu(),
            body: SingleChildScrollView(
              // reverse: true,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: const Text(
                        "Dịch vụ cấy",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    FutureBuilder(
                      future: callServiceApi("64756af6706fa019e6720d26"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 180,
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.map((item) {
                                int index = snapshot.data!.indexOf(item);
                                return InkWell(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                        backgroundColor: Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.95,
                                              child: ChiTietScreen(
                                                detail: item,
                                              ));
                                        });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          left: index != 0 ? 15 : 0),
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: Image.network(
                                              "$apiUrl${item["picture"]}?$token",
                                              height: 130,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${item["ten_vt"]}",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      )),
                                );
                              }).toList(),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: const Text(
                        "Dịch vụ xóa",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    FutureBuilder(
                      future: callServiceApi("64756ab8706fa019e6720cee"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 180,
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.map((item) {
                                int index = snapshot.data!.indexOf(item);
                                return InkWell(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                        backgroundColor: Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.95,
                                              child: ChiTietScreen(
                                                detail: item,
                                              ));
                                        });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          left: index != 0 ? 15 : 0),
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: Image.network(
                                              "$apiUrl${item["picture"]}?$token",
                                              height: 130,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${item["ten_vt"]}",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      )),
                                );
                              }).toList(),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 20),
                      child: const Text(
                        "Dịch vụ khác",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    FutureBuilder(
                        future: callServiceApi("64756b06706fa019e6720d40"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data!.map((item) {
                                int index = snapshot.data!.indexOf(item);
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: index != 0 ? 15 : 0),
                                  decoration: BoxDecoration(
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
                                  height: 140,
                                  child: TextButton(
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                          backgroundColor: Colors.white,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.95,
                                                child: ChiTietScreen(
                                                  detail: item,
                                                ));
                                          });
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image.network(
                                            "$apiUrl${item["picture"]}?$token",
                                            width: 110,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Wrap(
                                              children: [
                                                Text(
                                                  item["ten_vt"],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Html(style: {
                                                      "*": Style(
                                                          fontSize:
                                                              FontSize(12),
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          maxLines: 2,
                                                          margin:
                                                              Margins.all(0),
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis)
                                                    }, data: item["mieu_ta"])),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet<void>(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        context: context,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    15.0),
                                                          ),
                                                        ),
                                                        isScrollControlled:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                              padding: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .8,
                                                              child:
                                                                  ModalDiaChi(
                                                                activeService:
                                                                    item[
                                                                        "ten_vt"],
                                                              ));
                                                        });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              4,
                                                              4), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          6)),
                                                              color: Colors
                                                                  .red[200]),
                                                          child: Image.asset(
                                                            "assets/images/calendar-black.png",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                        const Text(
                                                          "Đặt lịch",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    _makingPhoneCall();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              4,
                                                              4), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            6)),
                                                                color: Colors
                                                                    .red[200]),
                                                            child: Image.asset(
                                                              "assets/images/call-black.png",
                                                              width: 20,
                                                              height: 20,
                                                            )),
                                                        const Text(
                                                          "Tư vấn",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )));
  }
}

class ModalDiaChi extends StatefulWidget {
  final String activeService;
  const ModalDiaChi({super.key, required this.activeService});

  @override
  State<ModalDiaChi> createState() => _ModalDiaChiState();
}

int active = -1;

class _ModalDiaChiState extends State<ModalDiaChi> {
  void chooseDiaChi(int index) {
    setState(() {
      active = index;
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
                                chooseDiaChi(index);
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
                                  Text(
                                    "${list[index]["ten_kho"]}",
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
          Container(
            height: 50,
            margin: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 20))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingStep2(
                              choose: active > 0 ? active : 0,
                              serviceName: activeServie,
                              maKho:
                                  active > 0 ? chiNhanh[active]["ma_kho"] : "",
                            )));
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
      ),
    );
  }
}
