import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/chi_tiet_dich_vu.dart';
import 'package:ngoc_huong/screen/services/modal_dia_chi_booking.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:url_launcher/url_launcher.dart';

class PhunXamScreen extends StatefulWidget {
  const PhunXamScreen({super.key});

  @override
  State<PhunXamScreen> createState() => _PhunXamScreenState();
}

class _PhunXamScreenState extends State<PhunXamScreen> {
  LocalStorage storage = LocalStorage('auth');
  LocalStorage storageToken = LocalStorage('token');
  @override
  initState() {
    super.initState();
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {});
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
              leadingWidth: 45,
              centerTitle: true,
              leading: InkWell(
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
              title: const Text("Phun Xăm",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            drawer: const MyLeftMenu(),
            body: RefreshIndicator(
              onRefresh: () => refreshData(),
              child: SingleChildScrollView(
                // reverse: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: const Text(
                          "Phun xăm mày",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("647569c2706fa019e6720bd4"),
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
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: index != 0 ? 15 : 0),
                                        width:
                                            MediaQuery.of(context).size.width /
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
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: const Text(
                          "Phun mí mắt",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("647569cb706fa019e6720bee"),
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
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: index != 0 ? 15 : 0),
                                        width:
                                            MediaQuery.of(context).size.width /
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
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: const Text(
                          "Phun xăm môi",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("647569d6706fa019e6720c08"),
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
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: index != 0 ? 15 : 0),
                                        width:
                                            MediaQuery.of(context).size.width /
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
                          "Xóa, sửa lại",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder(
                        future: callServiceApi("64756a1c706fa019e6720c22"),
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
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: index != 0 ? 15 : 0),
                                        width:
                                            MediaQuery.of(context).size.width /
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
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
