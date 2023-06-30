import 'package:flutter/material.dart';

Widget fieldAddress(
    BuildContext context, Function(String value) changeAddress) {
  return Column(
    children: [
      const Row(
        children: [
          Text("Địa chỉ",
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
        style: const TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
        onChanged: (value) {
          changeAddress(value);
        },
        decoration: InputDecoration(
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
          hintText: 'Nhập địa chỉ',
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}
