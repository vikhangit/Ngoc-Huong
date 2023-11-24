import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/utils/callapi.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class ChiTietTinTuc extends StatefulWidget {
  final Map detail;
  final String type;
  const ChiTietTinTuc({super.key, required this.detail, required this.type});

  @override
  State<ChiTietTinTuc> createState() => _ChiTietTinTucState();
}

class _ChiTietTinTucState extends State<ChiTietTinTuc> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    Map newsDetail = widget.detail;
    return SafeArea(
      bottom: false,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: ScrollToHide(
              scrollController: scrollController,
              height: 100,
              child: const MyBottomMenu(
                active: 0,
              )),
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
            title: Text(
                widget.type == "kiến thức làm đẹp"
                    ? "Kiến thức làm đẹp"
                    : "Chi tiết ${widget.type}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          body: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: [
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
              if (widget.type == "khuyến mãi")
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Color(0xFFFED766),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Html(
                    data: newsDetail["ShortDescription"],
                    style: {
                      "*": Style(
                          fontSize: FontSize(15),
                          lineHeight: LineHeight(1),
                          margin: Margins.all(0)),
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
                        color: Colors.black),
                    "img": Style(
                        height: Height.auto(),
                        width: Width(MediaQuery.of(context).size.width)),
                    "*:not(img)": Style(
                        lineHeight: const LineHeight(1.5),
                        margin: Margins.only(left: 0, top: 10, bottom: 10))
                  },
                ),
              ),
            ],
          )),
    );
  }
}
