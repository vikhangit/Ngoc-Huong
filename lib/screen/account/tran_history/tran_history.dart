import 'package:flutter/material.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';

class TranHistory extends StatefulWidget {
  const TranHistory({super.key});

  @override
  State<TranHistory> createState() => _MyWidgetState();
}

int? _selectedIndex;

class _MyWidgetState extends State<TranHistory> with TickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_getActiveTabIndex);
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController?.index;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            // bottomOpacity: 0.0,
            primary: false,
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
            title: const Text("Lịch sử giao dịch",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            bottom: TabBar(
              controller: tabController,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: "LexendDeca"),
              onTap: (tabIndex) {
                setState(() {
                  _selectedIndex = tabIndex;
                });
              },
              tabs: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 45,
                  child: const Tab(
                    text: "Tích điểm",
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 45,
                  child: const Tab(
                    text: "Dùng diểm",
                  ),
                )
              ],
            ),
          ),
          drawer: const MyLeftMenu(),
          body: SizedBox(
            child: Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Image.asset("assets/images/account/img.webp"),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Image.asset("assets/images/account/img.webp"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
