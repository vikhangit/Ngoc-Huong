import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/utils/callapi.dart';
// import 'package:localstorage/localstorage.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

int value = 0;
List province = [];
String valueSearch = "";
List resultSearch = [];

class _StartScreenState extends State<StartScreen> {
  final LocalStorage storage = LocalStorage('auth');
  late TextEditingController controller;
  @override
  void initState() {
    callProvinceApi().then((value) => setState(() => province = value));
    controller = TextEditingController(text: valueSearch);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void searchProvice(String keyword) {
    setState(() {
      valueSearch = keyword;
      resultSearch.clear();
    });
    province.map(
      (element) {
        if (element["name"]
            .toString()
            .replaceAll("Tỉnh", "")
            .replaceAll("Thành phố", "")
            .toLowerCase()
            .contains(keyword.toLowerCase())) {
          setState(() {
            resultSearch.add(element);
          });
        }
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Vị trí của bạn",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                autofocus: false,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                onChanged: (value) {
                  searchProvice(value);
                },
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search_outlined,
                    size: 30,
                    color: Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context)
                            .colorScheme
                            .primary), //<-- SEE HERE
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                  hintText: 'Nhập để tìm kiếm',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: resultSearch.isNotEmpty
                    ? resultSearch.length
                    : province.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (resultSearch.isNotEmpty) {
                            value = resultSearch[index]["code"];
                          } else {
                            value = province[index]["code"];
                          }
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${resultSearch.isNotEmpty ? resultSearch[index]["name"] : province[index]["name"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          resultSearch.isNotEmpty &&
                                  value == resultSearch[index]["code"]
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : resultSearch.isEmpty &&
                                      value == province[index]["code"]
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : Container()
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            value > 0
                ? Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0))),
                    child: TextButton(
                        onPressed: () {
                          // storage.setItem("start", true);
                          storage.setItem("city_code", value);
                          Navigator.pushNamed(context, "home");
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(0.0))),
                        child: const Text("Tiếp tục",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white))),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0))),
                    child: const Text("Tiếp tục",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  )
          ],
        ),
      ),
    ));
  }
}
