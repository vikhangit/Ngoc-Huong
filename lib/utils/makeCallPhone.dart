import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

void makingPhoneCall() async {
 final LocalStorage storageBrand = LocalStorage('branch');
 Map brach = jsonDecode(storageBrand.getItem("branch"));
  var url = Uri(
    scheme: 'tel',
    path: brach["Hotline"],
  );
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
