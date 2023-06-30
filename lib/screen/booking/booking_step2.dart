import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/booking/confirm_booking.dart';
import 'package:ngoc_huong/utils/callapi.dart';

class BookingStep2 extends StatefulWidget {
  final String serviceName;
  final Map activeCN;
  const BookingStep2(
      {super.key, required this.serviceName, required this.activeCN});

  @override
  State<BookingStep2> createState() => _BookingStep2State();
}

List<DateTime?> _singleDatePickerValueWithDefaultValue = [
  DateTime.now(),
];
List<String> weekDaysName = [
  'CN',
  'Thứ 2',
  'Thứ 3',
  'Thứ 4',
  'Thứ 5',
  'Thứ 6',
  'Thứ 7'
];
int activeChiNhanhTuVan = -1;
List chiNhanh = [];
int activeDichVuTuVan = -1;
String dienGiai = "";
// int dayActive =
//     DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()).day;
String activeDate = DateFormat("dd/MM/yyyy").format(
    DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
String activeDate2 = DateFormat("yyyy-MM-dd").format(
    DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
String activeTime = "";
List timeList = [];

class _BookingStep2State extends State<BookingStep2> {
  final LocalStorage storage = LocalStorage('auth');
  LocalStorage storageToken = LocalStorage('token');

  @override
  void initState() {
    setState(() {
      dienGiai = "";
      activeTime = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    activeTime = "";
    super.dispose();
  }

  void chooseTime(String time) {
    setState(() {
      activeTime = time;
    });
  }

  String dateTuVan = "";
  void selectDate(BuildContext context) {
    DatePickerBdaya.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2010, 3, 5),
        maxTime: DateTime(3000, 12, 31),
        theme: const DatePickerThemeBdaya(
          itemStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          doneStyle: TextStyle(fontSize: 14),
        ),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        dateTuVan = DateFormat("dd/MM/yyyy").format(date);
      });
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }

  void showAlertDialog(BuildContext context, String err) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.pop(context, 'OK'),
    );
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return SizedBox(
            // height: 30,
            width: MediaQuery.of(context).size.width,
            child: Text(
              style: const TextStyle(height: 1.6),
              err,
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String serviceName = widget.serviceName;
    String activeDay = DateFormat("dd").format(
        DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
    String activeMonth = DateFormat("MM").format(
        DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
    String activeYear = DateFormat("yyyy").format(
        DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            // bottomNavigationBar: const MyBottomMenu(
            //   active: 0,
            // ),
            appBar: AppBar(
                bottomOpacity: 0.0,
                elevation: 0.0,
                leadingWidth: 40,
                centerTitle: true,
                backgroundColor: Colors.white,
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
                title: const Text("Đặt lịch",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black))),
            drawer: const MyLeftMenu(),
            body: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.bottom +
                  500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        190 -
                        MediaQuery.of(context).viewInsets.bottom,
                    child: ListView(
                      children: [
                        SizedBox(
                          child: _buildDefaultSingleDatePickerWithValue(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Chọn giờ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              FutureBuilder(
                                future: callTimeBookingApi(
                                    widget.activeCN["ma_kho"],
                                    "$activeYear-$activeMonth-$activeDay"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 20),
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.3)),
                                      child: Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 6,
                                          runSpacing: 10,
                                          children: snapshot.data!.map((item) {
                                            print(item);
                                            int index =
                                                snapshot.data!.indexOf(item);
                                            return InkWell(
                                                onTap: () {
                                                  if (item["value"] == true) {
                                                  } else {
                                                    chooseTime(item["time"]);
                                                  }
                                                },
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                          color: item["value"] ==
                                                                  true
                                                              ? Colors.grey[350]
                                                              : Colors.white,
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                      activeTime == item["time"]
                                                                          ? 1
                                                                          : 0.1)),
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  5 -
                                                              15,
                                                      child: Text(
                                                        "${item["time"]}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                    if (activeTime ==
                                                        item["time"])
                                                      Positioned(
                                                        right: -1,
                                                        top: -1,
                                                        child: Container(
                                                          width: 8,
                                                          height: 8,
                                                          decoration: const BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                        ),
                                                      )
                                                  ],
                                                ));
                                          }).toList()),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                child: const Text(
                                  "Tên",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              FutureBuilder(
                                future: getProfile(storage.getItem("phone")),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text:
                                              "${snapshot.data![0]["ten_kh"]}"),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                      decoration: InputDecoration(
                                        filled: true, //<-- SEE HERE
                                        fillColor: Colors.grey[200],
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary), //<-- SEE HERE
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  Colors.grey), //<-- SEE HERE
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 18),
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            fontWeight: FontWeight.w300),
                                        hintText: 'Nhập tên',
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                child: const Text(
                                  "Số điện thoại",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              FutureBuilder(
                                future: getProfile(storage.getItem("phone")),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text:
                                              "${snapshot.data![0]["of_user"]}"),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                      decoration: InputDecoration(
                                        filled: true, //<-- SEE HERE
                                        fillColor: Colors.grey[200],
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary), //<-- SEE HERE
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  Colors.grey), //<-- SEE HERE
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 18),
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            fontWeight: FontWeight.w300),
                                        hintText: 'Nhập số điện thoại',
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                child: const Text(
                                  "Chi nhánh",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 18),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: FutureBuilder(
                                  future: callChiNhanhApiByCN(
                                      widget.activeCN["ma_kho"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        "${snapshot.data![0]["ten_kho"]}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                child: const Text(
                                  "Dịch vụ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 18),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: Text(
                                  serviceName,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                child: const Text(
                                  "Ghi chú",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              TextField(
                                maxLines: 6,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                onChanged: (value) {
                                  setState(() {
                                    dienGiai = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary), //<-- SEE HERE
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.grey), //<-- SEE HERE
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.3),
                                      fontWeight: FontWeight.w300),
                                  hintText: 'Nhập ghi chú',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        left: 15,
                        right: 15),
                    child: TextButton(
                        onPressed: () {
                          if (activeTime.isEmpty) {
                            showAlertDialog(context, "Bạn chưa chọn giờ");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfirmBooking(
                                          serviceName: serviceName,
                                          chinhanhName:
                                              widget.activeCN["ten_kho"],
                                          maKho: widget.activeCN["ma_kho"],
                                          diaChiCuThe: widget
                                              .activeCN["exfields"]["dia_chi"],
                                          time: activeTime,
                                          day: activeDay,
                                          month: activeMonth,
                                          year: activeYear,
                                        )));
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)))),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 20))),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            const Expanded(
                              flex: 8,
                              child: Center(
                                child: Text(
                                  "Tiếp tục",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/calendar-white.png",
                                width: 25,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            )));
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: Theme.of(context).colorScheme.primary,
      weekdayLabels: weekDaysName,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      dayTextStyle: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
      disabledDayTextStyle:
          const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
      selectableDayPredicate: (day) => !day
          .difference(DateTime.now().subtract(const Duration(days: 1)))
          .isNegative,
      customModePickerIcon: Container(),
      modePickerTextHandler: ({DateTime? monthDate}) {
        return "Tháng ${monthDate?.month}, ${monthDate?.year}";
      },
    );
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CalendarDatePicker2(
            config: config,
            value: _singleDatePickerValueWithDefaultValue,
            onValueChanged: (dates) => setState(() {
                  _singleDatePickerValueWithDefaultValue = dates;
                  activeTime = "";
                })));
  }
}
