import 'package:flutter/material.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:ngoc_huong/utils/validate.dart';

Widget phoneField(Function(String value) changeValue) {
  final DataCustom dataCustom = DataCustom();
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 6),
          child: Text(
            "Số điện thoại",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
        TextFormField(
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabledBorder: dataCustom.border,
              focusedBorder: dataCustom.border,
              errorBorder: dataCustom.border2,
              focusedErrorBorder: dataCustom.border2,
              contentPadding:
                  const EdgeInsets.only(left: 6, right: 15, top: 0, bottom: 0),
              prefixIcon: SizedBox(
                width: 82,
                child: Row(children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.smartphone_rounded,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 4, right: 8),
                      child: Text(
                        "+84",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.8)),
                      )),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.black.withOpacity(0.6),
                  )
                ]),
              )),
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.8)),
          onChanged: changeValue,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng số điện thoại';
            } else if (value.indexOf("0") == 0) {
              if (!value.isValidPhone) {
                return 'Số điện thoại không hợp lệ';
              }
            }
            if (value.indexOf("0") != 0) {
              if (!"0$value".isValidPhone) {
                return 'Số điện thoại không hợp lệ';
              }
            }
            return null;
          },
        )
      ],
    ),
  );
}
