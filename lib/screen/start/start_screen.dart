import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/utils/callapi.dart';
// import 'package:localstorage/localstorage.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

String provinceId = "";
String valueSearch = "";

class _StartScreenState extends State<StartScreen> {
  final LocalStorage storage = LocalStorage('auth');
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: valueSearch);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, "home");
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.pop(context);
    // });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chào mừng bạn đến với Ngọc Hường",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: CircularProgressIndicator(),
            )
            // Container(
            //   alignment: Alignment.center,
            //   child: const Text(
            //     "Vị trí của bạn",
            //     style: TextStyle(fontSize: 18),
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(top: 30, bottom: 20),
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: TextField(
            //     textAlignVertical: TextAlignVertical.center,
            //     autofocus: false,
            //     style: const TextStyle(
            //         fontSize: 15,
            //         color: Colors.black,
            //         fontWeight: FontWeight.w500),
            //     onChanged: (value) {
            //       setState(() {
            //         valueSearch = value;
            //       });
            //     },
            //     controller: controller,
            //     decoration: InputDecoration(
            //       prefixIcon: const Icon(
            //         Icons.search_outlined,
            //         size: 30,
            //         color: Colors.black,
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: const BorderRadius.all(Radius.circular(10)),
            //         borderSide: BorderSide(
            //             width: 1,
            //             color: Theme.of(context)
            //                 .colorScheme
            //                 .primary), //<-- SEE HERE
            //       ),
            //       enabledBorder: const OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(10)),
            //         borderSide:
            //             BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
            //       ),
            //       contentPadding:
            //           const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            //       hintStyle: const TextStyle(
            //           fontSize: 15,
            //           color: Colors.black,
            //           fontWeight: FontWeight.w300),
            //       hintText: 'Nhập để tìm kiếm',
            //     ),
            //   ),
            // ),
            // FutureBuilder(
            //   future: callProvinceApi(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Expanded(
            //         child: ListView(
            //             shrinkWrap: true,
            //             physics: const ClampingScrollPhysics(),
            //             children: snapshot.data!.map((item) {
            //               if (item["province_name"]
            //                   .toString()
            //                   .replaceAll("Tỉnh", "")
            //                   .replaceAll("Thành phố", "")
            //                   .toLowerCase()
            //                   .contains(valueSearch.toLowerCase())) {
            //                 return Container(
            //                   margin:
            //                       const EdgeInsets.only(left: 10, right: 10),
            //                   height: 50,
            //                   child: TextButton(
            //                     onPressed: () {
            //                       setState(() {
            //                         provinceId = item["province_id"];
            //                       });
            //                     },
            //                     style: ButtonStyle(
            //                         padding: MaterialStateProperty.all(
            //                             const EdgeInsets.symmetric(
            //                                 vertical: 0, horizontal: 10))),
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text(
            //                           "${item["province_name"]}",
            //                           style: const TextStyle(
            //                               fontWeight: FontWeight.w300,
            //                               fontSize: 16,
            //                               color: Colors.black),
            //                         ),
            //                         if (provinceId == item["province_id"])
            //                           const Icon(
            //                             Icons.check,
            //                             color: Colors.green,
            //                           )
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               } else {
            //                 return Container();
            //               }
            //             }).toList()),
            //       );
            //     } else {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   },
            // ),
            // provinceId.isNotEmpty
            //     ? Container(
            //         margin: const EdgeInsets.only(top: 20),
            //         width: MediaQuery.of(context).size.width,
            //         height: 60,
            //         decoration: BoxDecoration(
            //             color: Theme.of(context).colorScheme.primary,
            //             borderRadius:
            //                 const BorderRadius.all(Radius.circular(50.0))),
            //         child: TextButton(
            //             onPressed: () {
            //               // storage.setItem("start", true);
            //               storage.setItem("city_code", provinceId.toString());

            //               Navigator.pushNamed(context, "home");
            //             },
            //             style: ButtonStyle(
            //                 padding: MaterialStateProperty.all(
            //                     const EdgeInsets.all(0.0))),
            //             child: const Text("Tiếp tục",
            //                 style:
            //                     TextStyle(fontSize: 16, color: Colors.white))),
            //       )
            //     : Container(
            //         width: MediaQuery.of(context).size.width,
            //         alignment: Alignment.center,
            //         height: 60,
            //         decoration: BoxDecoration(
            //             color: Colors.grey.withOpacity(0.3),
            //             borderRadius:
            //                 const BorderRadius.all(Radius.circular(50.0))),
            //         child: const Text("Tiếp tục",
            //             style: TextStyle(fontSize: 16, color: Colors.black)),
            //       )
          ],
        ),
      ),
    ));
  }
}
