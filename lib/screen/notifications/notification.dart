import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  LocalStorage storageToken = LocalStorage("token");
  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
  }

  void readNotify(id) {
    Map data = {"status": true};
    readNotifications(id, data).then((value) => setState(() {}));
  }

  void readAll(List list) {
    Map data = {"status": true};
    for (var i = 0; i < list.length; i++) {
      readNotifications(list[i]["_id"], data).then((value) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: MyBottomMenu(active: 2, save: () => setState(() {})),
      drawer: const MyLeftMenu(),
      appBar: AppBar(
        leadingWidth: 45,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
              future: callNotificationsApi(),
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
                  return const Center(
                    child: CircularProgressIndicator(),
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
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: FutureBuilder(
            future: callNotificationsApi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List listNotify = snapshot.data!.toList();
                if (listNotify.isNotEmpty) {
                  return ListView.builder(
                    itemCount: listNotify.length,
                    itemBuilder: (context, index) {
                      if (listNotify[index]["exfields"]["id_app"] == idApp) {
                        return Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
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
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 5))),
                            onPressed: () {
                              readNotify(listNotify[index]["_id"]);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(listNotify[index]["status"] == false
                                    ? "assets/images/Notifications/bell2.png"
                                    : "assets/images/Notifications/bell1.png"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${listNotify[index]["title"]}",
                                            style: TextStyle(
                                                color: listNotify[index]
                                                            ["status"] ==
                                                        false
                                                    ? Colors.black
                                                    : Colors.black38,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "${listNotify[index]["exfields"]["content"]}",
                                            style: TextStyle(
                                                color: listNotify[index]
                                                            ["status"] ==
                                                        false
                                                    ? Colors.black
                                                    : Colors.black38,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (listNotify[index]["status"] == false)
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
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
                        margin: const EdgeInsets.symmetric(horizontal: 15),
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
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
    ));
  }
}
