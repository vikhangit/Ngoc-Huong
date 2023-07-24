import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ngoc_huong/constants/variable.dart';

List<Banner> bannerFormJson(String str) =>
    List<Banner>.from(json.decode(str).map((x) => Banner.fromJson(x)));
String bannerToJson(List<Banner> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class Banner {
  final int id;
  final String image;
  const Banner({required this.id, required this.image});
  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['_id'],
      image: json['hinh_anh'],
    );
  }
  Map<String, dynamic> toJson() => {
        '_id': id,
        'hinh_anh': image,
      };
}
