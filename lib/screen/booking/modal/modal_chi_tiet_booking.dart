import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/branchsModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class ModalChiTietBooking extends StatefulWidget {
  final Map details;
  final Function? save;
  final String? status;
  final String? history;
  const ModalChiTietBooking(
      {super.key, required this.details, this.save, this.status, this.history});

  @override
  State<ModalChiTietBooking> createState() => _ModalChiTietBookingState();
}

class _ModalChiTietBookingState extends State<ModalChiTietBooking> {
  final ServicesModel servicesModel = ServicesModel();
  final BranchsModel branchsModel = BranchsModel();
  @override
  Widget build(BuildContext context) {
    Map details = widget.history != null ? widget.details : widget.details["Data"];
    void cancleOrder() async {
      Map data = {"dien_giai": "Chờ trả"};
      await putBooking(details["_id"], data).then((value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const BookingHistory(
                    ac: 2,
                  ))));
      widget.save!();
    }
    print("=============================");
    print("Detaoasdasad: ${details}");
    print("=============================");
    DateTime databook = DateTime.parse(details["StartDate"]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(bottom: 20),
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
              const Expanded(
                flex: 84,
                child: Center(
                  child: Text(
                    "Chi đặt lịch",
                    style: TextStyle(
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8 -
              (details["dien_giai"] == "Đang chờ" ? 155 : 100),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              widget.history == null ?
              FutureBuilder(future: servicesModel.getAllServiceByGroup(), builder: (context, snapshot) {
                if(snapshot.hasData){
                  Map detailProduct =  snapshot.data!.firstWhere((e) => e["Name"]
                      .toString()
                      .toLowerCase() == details["ServiceList"][0].toString().toLowerCase(), orElse: () => null);
                 return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children:  [
                     SizedBox(
                       width: MediaQuery.of(context).size.width,
                       child: ClipRRect(
                         borderRadius: const BorderRadius.all(Radius.circular(10)),
                         child: Image.network(
                           "${detailProduct["Image_Name"]}",
                           // height: 210,
                           width: MediaQuery.of(context).size.width,
                         ),
                       ),
                     ),
                     Container(
                         margin: const EdgeInsets.symmetric(horizontal: 15),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const SizedBox(
                               height: 20,
                             ),
                             Text(
                               detailProduct["Name"],
                               style: const TextStyle(fontSize: 17),
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
                             const Text(
                               "Thông tin đặt lịch",
                               style: TextStyle(fontSize: 15),
                             ),
                             const SizedBox(
                               height: 15,
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     Expanded(
                                         child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Text(
                                           "Tháng ${databook.month < 10 ? "0${databook.month}" : databook.month}, ${databook.year}",
                                           style: const TextStyle(
                                               color: Colors.black, fontSize: 20),
                                         ),
                                         Text(
                                           "${databook.day < 10 ? "0${databook.day}" : databook.day}",
                                           style: const TextStyle(
                                               color: Colors.black, fontSize: 80),
                                         )
                                       ],
                                     )),
                                     Expanded(
                                         child: Column(
                                       children: [
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Container(
                                               padding: const EdgeInsets.symmetric(
                                                   vertical: 4, horizontal: 15),
                                               decoration: BoxDecoration(
                                                   color: Theme.of(context)
                                                       .colorScheme
                                                       .primary
                                                       .withOpacity(0.2),
                                                   borderRadius:
                                                       const BorderRadius.all(
                                                           Radius.circular(10))),
                                               child: Text(
                                                 widget!.status == null ? "Sắp tới" : "${details["Status"]}",
                                                 style: TextStyle(
                                                     color: Theme.of(context)
                                                         .colorScheme
                                                         .primary,
                                                     fontSize: 10,
                                                     fontWeight: FontWeight.w300),
                                               ),
                                             )
                                           ],
                                         ),
                                         const SizedBox(
                                           height: 15,
                                         ),
                                         Row(
                                           children: [
                                             Image.asset(
                                               "assets/images/time-solid-black.png",
                                               width: 20,
                                               height: 20,
                                               fit: BoxFit.contain,
                                             ),
                                             const SizedBox(
                                               width: 5,
                                             ),
                                             Text("${databook.hour}:${databook.minute}",
                                               style: const TextStyle(
                                                   color: Colors.black,
                                                   fontWeight: FontWeight.w300),
                                             )
                                           ],
                                         ),
                                         const SizedBox(
                                           height: 15,
                                         ),
                                         Row(
                                           crossAxisAlignment:
                                               CrossAxisAlignment.start,
                                           children: [
                                             Image.asset(
                                               "assets/images/location-solid-black.png",
                                               width: 20,
                                               height: 20,
                                               fit: BoxFit.contain,
                                             ),
                                             const SizedBox(
                                               width: 5,
                                             ),
                                             Flexible(
                                                 child: Text(
                                                   "${details["BranchInfo"]["Address"]}",
                                                   style: const TextStyle(
                                                       color: Colors.black,
                                                       fontSize: 14,
                                                       fontWeight: FontWeight.w300),
                                                 ))
                                           ],
                                         ),
                                       ],
                                     ))
                                   ],
                                 ),
                               ],
                             ),

                           ],
                         )),
                   ]
                 );
                }else{
                  return const Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
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
                    ],
                  );
                }
              },) :

              FutureBuilder(future: servicesModel.getServiceByName(widget.details["serviceList"][0]["ServiceName"]), builder: (context, snapshot) {
                if(snapshot.hasData){
                  Map detailProduct =  snapshot.data!;
                  return Column(
                      children:  [
                        Center(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              "${detailProduct["Image_Name"]}",
                              // height: 210,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  detailProduct["Name"],
                                  style: const TextStyle(fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      NumberFormat.currency(locale: "vi_VI", symbol: "đ")
                                          .format(
                                        detailProduct["PriceOutbound"],
                                      ),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.primary),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     const Icon(
                                    //       Icons.star,
                                    //       size: 20,
                                    //       color: Colors.orange,
                                    //     ),
                                    //     Container(
                                    //       margin:
                                    //       const EdgeInsets.symmetric(horizontal: 5),
                                    //       child: const Text("4.8"),
                                    //     ),
                                    //     const Text(
                                    //       "(130 đánh giá)",
                                    //       style: TextStyle(fontWeight: FontWeight.w300),
                                    //     )
                                    //   ],
                                    // )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Thông tin đặt lịch",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Tháng ${databook.month < 10 ? "0${databook.month}" : databook.month}, ${databook.year}",
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 20),
                                                ),
                                                Text(
                                                  "${databook.day < 10 ? "0${databook.day}" : databook.day}",
                                                  style: const TextStyle(
                                                      color: Colors.black, fontSize: 80),
                                                )
                                              ],
                                            )),
                                        Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 4, horizontal: 15),
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(10))),
                                                      child: Text(
                                                        widget!.status == null ? "Sắp tới" : "${widget.status}",
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w300),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/time-solid-black.png",
                                                      width: 20,
                                                      height: 20,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("${DateFormat("HH:mm").format(databook)}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w300),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/location-solid-black.png",
                                                      width: 20,
                                                      height: 20,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    FutureBuilder(future: branchsModel.getBranchs(), builder: (context, snapshot) {
                                                      if(snapshot.hasData){
                                                        Map address = snapshot.data!.firstWhere((e) => e["Name"]
                                                            == details["BranchName"], orElse: () => null);
                                                        print(address);
                                                        return Flexible(
                                                            child: Text(
                                                              "${address["Address"]}",
                                                              style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w300),
                                                            ));
                                                      }else{
                                                        return Container();
                                                      }
                                                    },)
                                                  ],
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            )),

                      ]
                  );
                }else{
                  return   Container( margin: const EdgeInsets.only(top: 60), child: const Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
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
                    ],
                  ));
                }
              },)
             ],
          ),
        ),
        // if (details["dien_giai"] == "Đang chờ")
        //   Container(
        //     margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
        //     child: TextButton(
        //         onPressed: () {
        //           showInfoDialog();
        //         },
        //         style: ButtonStyle(
        //             shape: MaterialStateProperty.all(
        //                 const RoundedRectangleBorder(
        //                     borderRadius:
        //                         BorderRadius.all(Radius.circular(15)))),
        //             backgroundColor: MaterialStateProperty.all(
        //                 Theme.of(context).colorScheme.primary),
        //             padding: MaterialStateProperty.all(
        //                 const EdgeInsets.symmetric(
        //                     vertical: 12, horizontal: 20))),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const Text(
        //               "Hủy đặt lịch",
        //               style: TextStyle(
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w400,
        //                   color: Colors.white),
        //             ),
        //             const SizedBox(
        //               width: 15,
        //             ),
        //             Image.asset(
        //               "assets/images/calendar-white.png",
        //               width: 24,
        //               height: 34,
        //               fit: BoxFit.contain,
        //             ),
        //           ],
        //         )),
        //   )
      ],
    );
  }
}
