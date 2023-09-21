import 'package:flutter/material.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

Widget fieldPhone(BuildContext context, Function(String name) changeName,
    TextEditingController controller) {
  final DataCustom dataCustom = DataCustom();
  final CustomModal customModal = CustomModal();
  return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const Row(
            children: [
              Text("Số điện thoại",
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
              // changeName(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ và tên';
              }
              return null;
            },
            onTap: () => customModal.showAlertDialog(
                context,
                "error",
                "Cảnh báo",
                "Số điện thoại không thể thay đôỉ",
                () => Navigator.pop(context),
                () => Navigator.pop(context)),
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: dataCustom.border,
              enabledBorder: dataCustom.border,
              errorBorder: dataCustom.border2,
              focusedErrorBorder: dataCustom.border2,
              fillColor: Colors.grey[200],
              filled: true,
              prefix: const Padding(padding: EdgeInsets.only(left: 10)),
              contentPadding: const EdgeInsets.only(
                  left: 5, top: 18, right: 15, bottom: 18),
            ),
          ),
        ],
      ));
}
