import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/appInfoController.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:upgrader/upgrader.dart';

class VanChuyenScreen extends StatefulWidget {
  const VanChuyenScreen({super.key});

  @override
  State<VanChuyenScreen> createState() => _VanChuyenScreenState();
}

class _VanChuyenScreenState extends State<VanChuyenScreen> {
  final AppInfoModel appInfoModel = AppInfoModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      bottom: false, top: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
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
            title: const Text("Chính sách vận chuyển giao hàng",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          bottomNavigationBar: const MyBottomMenu(active: 4),
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: FutureBuilder(
                  future: appInfoModel.getAppInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                          child: ListView(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 30),
                        children: [
                          snapshot.data!["exfields"]["cs_vanchuyen_giaohang"] !=
                                  null
                              ? Html(
                                  data: snapshot.data!["exfields"]
                                      ["cs_vanchuyen_giaohang"],
                                  style: {
                                    "*": Style(
                                        fontSize: FontSize(15),
                                        margin: Margins.only(left: 0, right: 0),
                                        textAlign: TextAlign.justify),
                                    "ul": Style(fontWeight: FontWeight.w300),
                                    "p": Style(
                                        lineHeight: const LineHeight(1.8),
                                        fontSize: FontSize(15),
                                        fontWeight: FontWeight.w300,
                                        textAlign: TextAlign.justify),
                                    "img": Style(margin: Margins.only(top: 5))
                                    //   "img": Style(
                                    //     width: Width(MediaQuery.of(context).size.width * .85),
                                    //     margin: Margins.only(top: 10, bottom: 6, left: 15, right: 0),
                                    //     textAlign: TextAlign.center
                                    //   )
                                  },
                                )
                              : Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 40, bottom: 15),
                                      child: Image.asset(
                                          "assets/images/account/img.webp"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: const Text(
                                        'Chúng tôi đang cập nhật thông tin về Ngọc Hường Beauty',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      ));
                    } else {
                      return const Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                            ]),
                      );
                    }
                  }))),
    );
  }
}
