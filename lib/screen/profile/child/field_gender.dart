import 'package:flutter/material.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

Widget gender(BuildContext context, Function(int index) changeGender,
    int genderActive, List genderList) {
  final DataCustom dataCustom = DataCustom();
  return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const Row(
            children: [
              Text("Giới tính",
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
            readOnly: true,
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              prefixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: genderList.map(
                    (element) {
                      int index = genderList.indexOf(element);
                      return Expanded(
                          child: GestureDetector(
                        onTap: () {
                          changeGender(index);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: index == 0 ? 0 : 10,
                              right: index == 1 ? 0 : 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 15),
                          decoration: BoxDecoration(
                              color: genderActive == index
                                  ? mainColor
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                  width: 1,
                                  color: index == genderActive
                                      ? mainColor
                                      : Colors.black)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
                                          border: Border.all(
                                              width: 1.5,
                                              color: genderActive == index
                                                  ? Colors.white
                                                  : Colors.black)),
                                      margin: const EdgeInsets.only(right: 8),
                                      child: index == genderActive
                                          ? const Icon(
                                              Icons.circle,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null),
                                  Text(
                                    "${element["title"]}",
                                    style: TextStyle(
                                        color: genderActive == index
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Image.asset(
                                genderActive == index
                                    ? element["iconActive"]
                                    : element["icon"],
                                width: 24,
                                height: 24,
                              )
                            ],
                          ),
                        ),
                      ));
                    },
                  ).toList()),
              contentPadding: const EdgeInsets.only(
                  left: 15, top: 18, right: 15, bottom: 18),
            ),
          ),
        ],
      ));
}
