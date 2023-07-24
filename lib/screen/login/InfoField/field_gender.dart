import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/login/modal_Info.dart';

Widget gender(BuildContext context, Function(String value) changeGender) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: genderList.map(
          (element) {
            return Expanded(
                child: GestureDetector(
              onTap: () {
                changeGender(element);
              },
              child: Row(
                children: [
                  Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          border: Border.all(
                              width: 1,
                              color: genderValue == element
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.black)),
                      margin: const EdgeInsets.only(right: 8),
                      child: element == genderValue
                          ? Icon(
                              Icons.circle,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null),
                  Text(
                    "$element",
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ));
          },
        ).toList()),
  );
}
