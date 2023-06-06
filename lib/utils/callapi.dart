import 'package:dio/dio.dart';

String apiUrl = "https://api.fostech.vn";
String idApp = "646ac3388b2b2d2d01848092";
String token = "access_token=1766b0baa43fd672a1730ac4a4ab3849";

Future<List> callNewsApi(String id) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/news?limit=100&q={"status":true,"category":"$id"}&$token');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callBannerHoemApi() async {
  List allBanner = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/banner?limit=3&q={"status":true,"danh_muc":"Banner Home"}&$token');
  for (var data in response.data) {
    allBanner.add(data);
  }
  return allBanner;
}

Future<List> callChiNhanhApi() async {
  List allBanner = [];
  final dio = Dio();
  final response = await dio
      .get('$apiUrl/api/$idApp/dmkho?limit=100&q={"status":true}&$token');
  for (var data in response.data) {
    if (data["status"] == true) {
      allBanner.add(data);
    }
  }
  return allBanner;
}

Future<List> callChiNhanhApiByCN(String maKho) async {
  List allBanner = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmkho?limit=100&q={"status":true, "ma_kho": "$maKho"}&$token');
  for (var data in response.data) {
    allBanner.add(data);
  }
  return allBanner;
}

Future<List> callServiceApi(String id) async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt?limit=100&q={"ma_nvt":"$id","is_service":true,"status":true}&$token');
  for (var data in response.data) {
    allService.add(data);
  }
  return allService;
}

Future<List> callServiceApiById(String id, String mavt) async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt/$id?limit=50&q={"ma_nvt":"$mavt","is_service":true,"status":true}&$token');
  for (var data in response.data) {
    allService.add(data);
  }
  return allService;
}

Future<List> callProductApi(String id) async {
  List list = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt?limit=100&q={"ma_nvt":"$id","is_service":false,"status":true}&$token');
  for (var data in response.data) {
    list.add(data);
  }
  return list;
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

Future<List> callTimeBookingApi(String maKho, String date) async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/fos_dsgio?$token&ma_kho=$maKho&ngay=$date&loai=1');
  for (var data in response.data) {
    allService.add(data);
  }
  return allService;
}

Future postLienHeTuVan(Map list) async {
  final dio = Dio();
  final response =
      await dio.post('$apiUrl/api/$idApp/lienhe?$token', data: list);
  // print(response);
}

Future<List> callBookingApi() async {
  List allNews = [];
  final dio = Dio();
  final response = await dio
      .get('$apiUrl/api/$idApp/tt_book?limit=50&q={"status":true}&$token');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future postBooking(Map list) async {
  final dio = Dio();
  final response =
      await dio.post('$apiUrl/api/$idApp/tt_book?$token', data: list);
  // print(response);
}
