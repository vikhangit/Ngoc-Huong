import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ChiTietTinTuc extends StatefulWidget {
  final Map detail;
  const ChiTietTinTuc({super.key, required this.detail});

  @override
  State<ChiTietTinTuc> createState() => _ChiTietTinTucState();
}

class _ChiTietTinTucState extends State<ChiTietTinTuc> {
  @override
  Widget build(BuildContext context) {
    Map uudaiDetail = widget.detail;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 8,
                  child: SizedBox(
                    height: 20,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.west,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  )),
              Expanded(
                flex: 84,
                child: Center(
                  child: Text(
                    "Chi tiết ${uudaiDetail["cate_name"].toLowerCase()}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: MediaQuery.of(context).size.height * 0.95 - 85,
            child: Expanded(
                child: ListView(children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
                        offset: Offset(0, 3),
                        blurRadius: 8)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  child: Image.network(
                    "$apiUrl${uudaiDetail["picture"]}?$token",
                    width: MediaQuery.of(context).size.width - 40,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${uudaiDetail["title"]}",
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                DateFormat("dd/MM/yyyy")
                    .format(DateTime.parse(uudaiDetail["date_updated"])),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                child: Html(
                  data: uudaiDetail["content"],
                  style: {
                    "*:not(img)": Style(
                        lineHeight: LineHeight(1.5),
                        margin: Margins.only(left: 0))
                  },
                ),
              ),
            ])),
          ),
        ],
      ),
    );
  }
}
