import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final BookingModel bookingModel = BookingModel();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  void readNotify(int id) {
    EasyLoading.show(status: "Vui lòng chờ");
    bookingModel.readNotifications(id).then((value) => {
          setState(() {
            EasyLoading.dismiss();
          })
        });
  }

  void readAll(List list) {
    for (var i = 0; i < list.length; i++) {
      // readNotifications(list[i]["_id"]).then((value) => setState(() {}));
      EasyLoading.show(status: "Vui lòng chờ");
      bookingModel.readNotifications(list[i]["Id"]).then((value) => {
            setState(() {
              EasyLoading.dismiss();
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: ScrollToHide(
                scrollController: scrollController,
                height: 100,
                child: const MyBottomMenu(
                  active: -1,
                )),
            appBar: AppBar(
              leadingWidth: 45,
              centerTitle: true,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.west,
                      size: 16,
                      color: Colors.black,
                    ),
                  )),
              actions: [
                FutureBuilder(
                    future: bookingModel.getNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return IconButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 5))),
                            onPressed: () {
                              readAll(snapshot.data!.toList());
                            },
                            icon: const Icon(
                              Icons.done_all,
                              size: 24,
                              color: Colors.white,
                            ));
                      } else {
                        return const SizedBox(
                          width: 40,
                          height: 40,
                          child: LoadingIndicator(
                            colors: <Color>[
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white
                            ],
                            indicatorType: Indicator.lineSpinFadeLoader,
                            strokeWidth: 1,
                            // pathBackgroundColor: Colors.black45,
                          ),
                        );
                      }
                    }),
              ],
              title: const Text("Thông báo",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FutureBuilder(
                    future: bookingModel.getNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List listNotify = snapshot.data!.toList();
                        if (listNotify.isNotEmpty) {
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: listNotify.length,
                            itemBuilder: (context, index) {
                              if (listNotify[index]["ListService"] != null) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: 10,
                                      left: 15,
                                      right: 15,
                                      top: index == 0 ? 15 : 0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
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
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 5))),
                                    onPressed: () {
                                      readNotify(listNotify[index]["Id"]);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(listNotify[index]
                                                        ["IsRead"] ==
                                                    null ||
                                                !listNotify[index]["IsRead"]
                                            ? "assets/images/Notifications/bell2.png"
                                            : "assets/images/Notifications/bell1.png"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  110,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${listNotify[index]["ListService"]}",
                                                    style: TextStyle(
                                                        color: listNotify[index]
                                                                        [
                                                                        "IsRead"] ==
                                                                    null ||
                                                                !listNotify[
                                                                        index]
                                                                    ["IsRead"]
                                                            ? Colors.black
                                                            : Colors.black38,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "Bạn có lịch hẹn ${listNotify[index]["ListService"].toString().toLowerCase()} vào lúc ${DateFormat("HH:mm").format(DateTime.parse(listNotify[index]["StartDate"]))} ngày ${DateFormat("dd/MM/yyyy").format(DateTime.parse(listNotify[index]["StartDate"]))}",
                                                    style: TextStyle(
                                                        color: listNotify[index]
                                                                        [
                                                                        "IsRead"] ==
                                                                    null ||
                                                                !listNotify[
                                                                        index]
                                                                    ["IsRead"]
                                                            ? Colors.black
                                                            : Colors.black38,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (listNotify[index]["IsRead"] ==
                                                    null ||
                                                !listNotify[index]["IsRead"])
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    color: Color(0xFFDC202E)),
                                              )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        } else {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Image.asset(
                                    "assets/images/Notifications/noti1.png"),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: const Text(
                                  "Bạn chưa có thông báo nào trong 30 ngày gần đây",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: const Text(
                                  "Vui lòng thử lại sau!",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          );
                        }
                      } else {
                        return const Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: LoadingIndicator(
                                colors: kDefaultRainbowColors,
                                indicatorType: Indicator.lineSpinFadeLoader,
                                strokeWidth: 1,
                                // pathBackgroundColor: Colors.black45,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Đang lấy dữ liệu")
                          ],
                        ));
                      }
                    },
                  )),
            )));
  }
}
