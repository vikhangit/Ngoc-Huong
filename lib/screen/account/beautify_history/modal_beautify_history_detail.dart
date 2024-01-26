import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/bookingModel.dart';
import 'package:ngoc_huong/models/branchsModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/ModalZoomImage.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:upgrader/upgrader.dart';

class ModalBeautifyHistoryDetail extends StatefulWidget {
  final Map detailBooking;
  final Function? save;
  final List listImageUsing;
  const ModalBeautifyHistoryDetail(
      {super.key,
      required this.detailBooking,
      this.save,
      required this.listImageUsing});

  @override
  State<ModalBeautifyHistoryDetail> createState() =>
      _ModalBeautifyHistoryDetailState();
}

class _ModalBeautifyHistoryDetailState
    extends State<ModalBeautifyHistoryDetail> {
  final ServicesModel servicesModel = ServicesModel();
  final BranchsModel branchsModel = BranchsModel();
  final BookingModel bookingModel = BookingModel();
  final CustomModal customModal = CustomModal();
  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    Map detailBooking = widget.detailBooking;
    List imageList = widget.listImageUsing;
    return SafeArea(
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
              title: const Text("Lịch sử làm đẹp",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            body: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: UpgradeDialogStyle.cupertino,
                  canDismissDialog: false,
                  showLater: false,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ImageDetail(items: imageList),
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              detailBooking["ServiceName"],
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //   children: [
                                            //     Text(
                                            //       NumberFormat.currency(locale: "vi_VI", symbol: "đ")
                                            //           .format(
                                            //         detailProduct["PriceOutbound"],
                                            //       ),
                                            //       style: TextStyle(
                                            //           fontSize: 16,
                                            //           color: Theme.of(context).colorScheme.primary),
                                            //     ),
                                            //     // Row(
                                            //     //   children: [
                                            //     //     const Icon(
                                            //     //       Icons.star,
                                            //     //       size: 20,
                                            //     //       color: Colors.orange,
                                            //     //     ),
                                            //     //     Container(
                                            //     //       margin:
                                            //     //       const EdgeInsets.symmetric(horizontal: 5),
                                            //     //       child: const Text("4.8"),
                                            //     //     ),
                                            //     //     const Text(
                                            //     //       "(130 đánh giá)",
                                            //     //       style: TextStyle(fontWeight: FontWeight.w300),
                                            //     //     )
                                            //     //   ],
                                            //     // )
                                            //   ],
                                            // ),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
                                            // const Text(
                                            //   "Chi tiết",
                                            //   style: TextStyle(fontSize: 15),
                                            // ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/calendar-solid-black.png",
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.contain,
                                                      ),
                                                      const Text(
                                                          "Ngày thực hiện",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        DateFormat("dd/MM/yyyy")
                                                            .format(DateTime.parse(
                                                                detailBooking[
                                                                    "UsingServiceDate"])),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black))),
                                              ],
                                            ),
                                            if (detailBooking[
                                                    "ReExaminationDate"] !=
                                                null)
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            if (detailBooking[
                                                    "ReExaminationDate"] !=
                                                null)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/calendar-solid-black.png",
                                                          width: 20,
                                                          height: 20,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        const Text(
                                                            "Ngày hẹn kế tiếp",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          DateFormat(
                                                                  "dd/MM/yyyy")
                                                              .format(DateTime.parse(
                                                                  detailBooking[
                                                                      "ReExaminationDate"])),
                                                          textAlign:
                                                              TextAlign.right,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black)))
                                                ],
                                              ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Expanded(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        size: 22,
                                                      ),
                                                      Text(
                                                          "Nhân viên thực hiện",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        "${detailBooking["DetailList"][0]["StaffName"]}",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black)))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/location-solid-black.png",
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.contain,
                                                      ),
                                                      const Text(
                                                          "Chi nhánh thực hiện",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: FutureBuilder(
                                                        future: branchsModel
                                                            .getBranchDetails(
                                                                detailBooking[
                                                                    "BranchCode"]),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return Text(
                                                                "${detailBooking["BranchName"]} - ${snapshot.data!["Address"]}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black));
                                                          } else {
                                                            return const SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  LoadingIndicator(
                                                                colors:
                                                                    kDefaultRainbowColors,
                                                                indicatorType:
                                                                    Indicator
                                                                        .lineSpinFadeLoader,
                                                                strokeWidth: 1,
                                                                // pathBackgroundColor: Colors.black45,
                                                              ),
                                                            );
                                                          }
                                                        }))
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Expanded(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.description,
                                                        size: 22,
                                                      ),
                                                      Text("Thông tin chi tiết",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        "${detailBooking["DetailList"][0]["Status"][0]}"
                                                                .toUpperCase() +
                                                            "${detailBooking["DetailList"][0]["Status"]}"
                                                                .substring(1)
                                                                .toLowerCase(),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black)))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        )),
                                  ])
                            ],
                          ),
                        ),
                      ],
                    )))));
  }
}

class ImageDetail extends StatefulWidget {
  final List items;
  const ImageDetail({super.key, required this.items});

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

int currentIndex = 0;

class _ImageDetailState extends State<ImageDetail> {
  final CarouselController carouselController = CarouselController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    List newList = widget.items;
    List<String> result =
        List.generate(newList.length, (index) => newList[index]["FilePath"]);
    List<Widget> imgList = List<Widget>.generate(
      newList.length,
      (index) => Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            // color: checkColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModalZoomImage(
                        currentIndex: currentIndex, imageList: result)));
          },
          child: Image.network(
            result[index],
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: (imgList.length > 1)
            ? Column(
                children: [
                  CarouselSlider.builder(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        aspectRatio: 2,
                        height: 380,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                      itemCount: imgList.length,
                      itemBuilder: (context, index, realIndex) =>
                          imgList[index]),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      controller: scrollController,
                      children: result.map((e) {
                        int index = result.indexOf(e);
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndex = index;
                                carouselController.animateToPage(index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: index == 0 ? 0 : 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: currentIndex == index
                                        ? mainColor
                                        : Colors.white),
                              ),
                              child: Image.network(
                                e,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ));
                      }).toList(),
                    ),
                  )
                ],
              )
            : imgList.length == 1
                ? Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        // color: checkColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModalZoomImage(
                                    currentIndex: currentIndex,
                                    imageList: result)));
                      },
                      child: Image.network(
                        result[0],
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ))
                : Container());
  }
}
