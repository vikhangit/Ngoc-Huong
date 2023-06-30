import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngoc_huong/screen/login/modal_Info.dart';

Widget fieldBirthDay(
    BuildContext context, Function(BuildContext context) selectBirthDay) {
  return Column(
    children: [
      Row(
        children: const [
          Text("Ngày sinh",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
          SizedBox(
            width: 3,
          ),
          Text("*",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w300)),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      TextField(
        textAlignVertical: TextAlignVertical.center,
        // keyboardType: TextInputType.datetime,
        // maxLength: 10,
        // inputFormatters: [DateTextFormatter()],
        controller: TextEditingController(
          text: birthDay.isNotEmpty ? birthDay : "",
        ),
        readOnly: true,
        onTap: () => selectBirthDay(context),
        style: const TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          suffixIcon: const Icon(
            Icons.calendar_month_outlined,
            color: Colors.black45,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.primary), //<-- SEE HERE
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.black.withOpacity(0.3),
              fontWeight: FontWeight.w400),
          hintText: 'Nhập ngày sinh',
        ),
      ),
      const SizedBox(
        height: 25,
      ),
    ],
  );
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    //this fixes backspace bug
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, '/');
    return newValue.copyWith(
        text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll('/', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 1) {
        newString += seperator;
      }
      if (i == 3) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
