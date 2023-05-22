import 'package:dio/dio.dart';

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
