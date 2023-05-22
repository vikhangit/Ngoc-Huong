import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/menu/leftmenu.dart';
import 'package:ngoc_huong/screen/services/modal/modal_chi_nhanh_tu_van.dart';
import 'package:ngoc_huong/screen/services/modal/modal_dich_vu_tu_van.dart';

class BookingStep2 extends StatefulWidget {
  const BookingStep2({super.key});

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
List chiNhanhTuVan = ["TP Hồ Chí Minh", "Hà Nội", "Đà Nẵng", "Cần Thơ"];
int activeDichVuTuVan = -1;
List dichvuTuVan = ["Dịch vụ 1", "Dịch vụ 2", "Dịch vụ 3", "Dịch vụ 4"];
int activeWeekIndex =
    DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString())
        .weekday;
String weekNameActive =
    activeWeekIndex > 6 ? weekDaysName[0] : weekDaysName[activeWeekIndex];
int dayActive =
    DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()).day;
String monthActive = DateFormat("MM").format(
    DateTime.parse(_singleDatePickerValueWithDefaultValue[0].toString()));

int activeTime = 0;

class _BookingStep2State extends State<BookingStep2> {
  final LocalStorage storage = LocalStorage('auth');
  void chooseChiNhanhTuVan(int index) {
    setState(() {
      activeChiNhanhTuVan = index;
    });
    Navigator.pop(context);
  }

  void chooseDichVuTuVan(int index) {
    setState(() {
      activeDichVuTuVan = index;
    });
    Navigator.pop(context);
  }

  void chooseTime(int index) {
    setState(() {
      activeTime = index;
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

  @override
  Widget build(BuildContext context) {
    String firstName = storage.getItem("firstname");
    String lastName = storage.getItem("lastname");
    String phone = storage.getItem("phone");
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
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 20),
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
                                    alignment: WrapAlignment.spaceBetween,
                                    runSpacing: 10,
                                    children: List.generate(10, (index) {
                                      return InkWell(
                                          onTap: () {
                                            chooseTime(index);
                                          },
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(
                                                                activeTime ==
                                                                        index
                                                                    ? 1
                                                                    : 0.3)),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        5 -
                                                    15,
                                                child: Text("${index + 8}:00"),
                                              ),
                                              if (activeTime == index)
                                                Positioned(
                                                  right: -1,
                                                  top: -1,
                                                  child: Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: const BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                  ),
                                                )
                                            ],
                                          ));
                                    })),
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
                              TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: firstName + lastName),
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  filled: true, //<-- SEE HERE
                                  fillColor: Colors.grey[300],
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
                                  hintText: 'Nhập tên',
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
                                  "Số điện thoại",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              TextField(
                                readOnly: true,
                                controller: TextEditingController(text: phone),
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  filled: true, //<-- SEE HERE
                                  fillColor: Colors.grey[300],
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
                                  hintText: 'Nhập số điện thoại',
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
                                  "Chi nhánh",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0),
                                        ),
                                      ),
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ModalChiNhanhTuVan(
                                            chooseChiNhanhTuVan: (index) =>
                                                chooseChiNhanhTuVan(index),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        activeChiNhanhTuVan < 0
                                            ? "Chọn chi nhánh"
                                            : "${chiNhanhTuVan[activeChiNhanhTuVan]}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: activeChiNhanhTuVan < 0
                                                ? Colors.black.withOpacity(0.3)
                                                : Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: activeChiNhanhTuVan < 0
                                            ? Colors.black.withOpacity(0.3)
                                            : Colors.black,
                                      )
                                    ],
                                  ),
                                ),
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
                                  "Dịch vụ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0),
                                        ),
                                      ),
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .8,
                                          child: ModalDichVuTuVan(
                                            chooseDichVuTuVan: (index) =>
                                                chooseDichVuTuVan(index),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        activeDichVuTuVan < 0
                                            ? "Chọn dịch vụ"
                                            : "${dichvuTuVan[activeDichVuTuVan]}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: activeDichVuTuVan < 0
                                                ? Colors.black.withOpacity(0.3)
                                                : Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: activeDichVuTuVan < 0
                                            ? Colors.black.withOpacity(0.3)
                                            : Colors.black,
                                      )
                                    ],
                                  ),
                                ),
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
                        onPressed: () {},
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
                                "assets/images/calendar-black.png",
                                width: 25,
                                height: 25,
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
        fontWeight: FontWeight.w600,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 17),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      dayTextStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
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
                })));
  }
}
