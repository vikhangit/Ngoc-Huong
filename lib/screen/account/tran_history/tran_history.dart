import 'package:flutter/material.dart';

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
            title: const Text("Lịch sử giao dịch",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          body: SizedBox(
              child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TabBar(
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
              SizedBox(
                height: MediaQuery.of(context).size.height - 170,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Image.asset("assets/images/account/img.webp"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Image.asset("assets/images/account/img.webp"),
                    )
                  ],
                ),
              )
            ],
          ))),
    );
  }
}
