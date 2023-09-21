import 'package:flutter/material.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

Widget fieldName(BuildContext context, Function(String name) changeName,
    TextEditingController controller) {
  DataCustom dataCustom = DataCustom();
  return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const Row(
            children: [
              Text("Họ và tên",
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
            height: 6,
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
            onChanged: (value) {
              changeName(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ và tên';
              }
              return null;
            },
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: dataCustom.border,
              enabledBorder: dataCustom.border,
              errorBorder: dataCustom.border2,
              focusedErrorBorder: dataCustom.border2,
              prefix: const Padding(padding: EdgeInsets.only(left: 10)),
              contentPadding: const EdgeInsets.only(
                  left: 5, top: 18, right: 15, bottom: 18),
              hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w400),
              hintText: 'Họ của bạn...',
            ),
          ),
        ],
      ));
}
