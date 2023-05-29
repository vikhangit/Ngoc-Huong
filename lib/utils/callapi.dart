import 'package:dio/dio.dart';
import 'dart:convert' as convert;

String apiUrl = "https://api.fostech.vn";
String idApp = "646ac3388b2b2d2d01848092";
String token = "access_token=1766b0baa43fd672a1730ac4a4ab3849";

Future<List> callNewsApi() async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get('$apiUrl/api/$idApp/news?limit=500&$token');
  for (var data in response.data) {
    if (data["status"] == true) {
      allNews.add(data);
    }
  }
  return allNews;
}

Future<List> callProvinceApi() async {
  List allProvince = [];
  final dio = Dio();
  final response = await dio.get('https://provinces.open-api.vn/api/p');
  for (var data in response.data) {
    allProvince.add(data);
  }
  return allProvince;
}

Future<List> searchProvinceApi(keyword) async {
  List allProvince = [];
  final dio = Dio();
  final response =
      await dio.get('https://provinces.open-api.vn/api/p/search/?q=$keyword');
  print(response);
  // for (var data in response.data) {
  //   allProvince.add(data);
  // }
  return allProvince;
}
