import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/utils/callapi.dart';

Widget profile(BuildContext context) {
  LocalStorage storageToken = LocalStorage('token');
  return FutureBuilder(
    future: callProfile(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        Map profile = snapshot.data!;
        return Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                backgroundColor: const Color(0xff00A3FF),
                backgroundImage: NetworkImage(
                    "$apiUrl${profile["picture"]}?access_token=${storageToken.getItem("token")}}"),
                radius: 35.0,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Xin chào!",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                Text(
                  "${profile["name"]}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                )
              ],
            )
          ],
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}
