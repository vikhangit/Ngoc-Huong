import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

void makingPhoneCall() async {
  var url = Uri.parse("tel:19007067");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
