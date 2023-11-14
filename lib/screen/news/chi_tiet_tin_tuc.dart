import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ChiTietTinTuc extends StatefulWidget {
  final Map detail;
  final String type;
  const ChiTietTinTuc({super.key, required this.detail, required this.type});

  @override
  State<ChiTietTinTuc> createState() => _ChiTietTinTucState();
}

class _ChiTietTinTucState extends State<ChiTietTinTuc> {
  @override
  Widget build(BuildContext context) {
    Map newsDetail = widget.detail;
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30))),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        width: 36,
                        height: 36,
                        child: const Icon(
                          Icons.west,
                          size: 16,
                          color: Colors.black,
                        ),
                      )),
                ),
                Expanded(
                  flex: 84,
                  child: Center(
                    child: Text(
                      widget.type == "kiến thức làm đẹp" ? "Kiến thức làm đẹp" : "Chi tiết ${widget.type}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: MediaQuery.of(context).size.height * 0.85 - 100,
            color: Colors.white,
            child: ListView(children: [
              Container(
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
                    "${newsDetail["Image"]}",
                    width: MediaQuery.of(context).size.width - 40,
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
                      "${newsDetail["Title"]}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                DateFormat("dd/MM/yyyy")
                    .format(DateTime.parse(newsDetail["ModifiedDate"])),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
            if(widget.type == "khuyến mãi")  Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
             decoration: BoxDecoration(
               color: Color(0xFFFED766),
               borderRadius: BorderRadius.all(Radius.circular(10))
             ),
                child: Html(
                  data: newsDetail["ShortDescription"],
                  style: {
                    "*": Style(
                      fontSize: FontSize(15),
                      lineHeight: LineHeight(1),
                      margin: Margins.all(0)
                    ),
                    "*:not(strong)": Style(
                      fontWeight: FontWeight.w300,
                    ),
                    "*:not(img)": Style(
                        lineHeight: const LineHeight(1.5),
                        margin: Margins.only(left: 0, top: 10, bottom: 10))
                  },
                ),
              ),
              SizedBox(
                child: Html(
                  data: newsDetail["Content"],
                  style: {
                    "*": Style(
                      fontSize: FontSize(15),
                    ),
                    "a": Style(
                      textDecoration: TextDecoration.none,
                      color: Colors.black
                    ),
                    "img": Style(
                      height: Height.auto(),
                      width: Width(MediaQuery.of(context).size.width)
                    ),
                    "*:not(img)": Style(
                        lineHeight: const LineHeight(1.5),
                        margin: Margins.only(left: 0, top: 10, bottom: 10))
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
