import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

Widget fieldBirthDay(BuildContext context,
    Function(BuildContext context) selectBirthDay, DateTime? birthday) {
  final DataCustom theme = DataCustom();
  return Column(
    children: [
      const Row(
        children: [
          Text("Ngày sinh",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(
            width: 3,
          ),
          Text("*",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w500)),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        textAlignVertical: TextAlignVertical.center,
        controller: TextEditingController(
          text:
              birthday != null ? DateFormat("dd/MM/yyyy").format(birthday) : "",
        ),
        readOnly: true,
        onTap: () => selectBirthDay(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Vui lòng chọn ngày sinh";
          }
          return null;
        },
        style: const TextStyle(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          suffixIcon: Transform.scale(
            scale: 0.6,
            child: Image.asset(
              "assets/images/calendar-black.png",
              width: 20,
              height: 20,
            ),
          ),
          prefix: const Padding(padding: EdgeInsets.only(left: 10)),
          focusedBorder: theme.border,
          enabledBorder: theme.border,
          errorBorder: theme.border2,
          focusedErrorBorder: theme.border2,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 18),
          hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w400),
          hintText: 'Nhập ngày sinh',
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}
