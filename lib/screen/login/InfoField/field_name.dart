import 'package:flutter/material.dart';

Widget fieldName(BuildContext context, Function(String fName) changeFirstName,
    Function(String lName) changeLastName) {
  return Container(
    margin: const EdgeInsets.only(bottom: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 48,
            child: Column(
              children: [
                const Row(
                  children: [
                    Text("Họ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
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
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  onChanged: (value) {
                    changeFirstName(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .primary), //<-- SEE HERE
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey), //<-- SEE HERE
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 18),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.3),
                        fontWeight: FontWeight.w300),
                    hintText: 'Họ của bạn...',
                  ),
                ),
              ],
            )),
        Expanded(flex: 4, child: Container()),
        Expanded(
            flex: 48,
            child: Column(
              children: [
                const Row(
                  children: [
                    Text("Tên",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
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
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  onChanged: (value) {
                    changeLastName(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .primary), //<-- SEE HERE
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey), //<-- SEE HERE
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 18),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.3),
                        fontWeight: FontWeight.w300),
                    hintText: 'Tên của bạn...',
                  ),
                ),
              ],
            )),
      ],
    ),
  );
}
