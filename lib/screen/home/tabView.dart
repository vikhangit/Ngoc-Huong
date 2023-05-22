import 'package:flutter/material.dart';

class MyTabView extends StatefulWidget {
  const MyTabView({super.key});

  @override
  State<MyTabView> createState() => _MyTabViewState();
}

class _MyTabViewState extends State<MyTabView> with TickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(
      text: "Task Details",
    ),
    Tab(text: "Description Details"),
    Tab(text: "Services Details"),
    Tab(text: "SLA Infomation"),
  ];

  @override
  Widget build(BuildContext context) {
    TabController _tabController =
        TabController(vsync: this, length: myTabs.length);
    return Container(
        color: Colors.white,
        child: Expanded(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TabBar(
                controller: _tabController,
                tabs: myTabs,
                labelColor: Theme.of(context).colorScheme.primary,
                isScrollable: true,
                unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w400, fontFamily: "Poppins"),
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 300,
              child: Expanded(
                child: TabBarView(controller: _tabController, children: [
                  Center(
                    child: Text(
                      "Don't find unread notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Don't find unread notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Don't find unread notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Don't find unread notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
              ),
            )
          ]),
        ));
  }
}
