import 'package:flutter/material.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

Widget fieldAddress(
    BuildContext context,
    Function(String value) changeValueAddress,
    TextEditingController controller) {
  final DataCustom theme = DataCustom();
  return Column(
    children: [
      const Row(
        children: [
          Text("Địa chỉ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(
            width: 3,
          ),
          // Text("*",
          //     style: TextStyle(
          //         fontSize: 14,
          //         color: Colors.red,
          //         fontWeight: FontWeight.w500)),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
        onChanged: (value) {
          changeValueAddress(value);
        },
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return "Vui lòng nhập địa chỉ";
        //   }
        //   return null;
        // },
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: theme.border,
          enabledBorder: theme.border,
          errorBorder: theme.border2,
          focusedErrorBorder: theme.border2,
          prefix: const Padding(padding: EdgeInsets.only(left: 10)),
          contentPadding:
              const EdgeInsets.only(left: 5, top: 18, right: 15, bottom: 18),
          hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w400),
          hintText: 'Nhập địa chỉ',
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}
