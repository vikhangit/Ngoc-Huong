import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

String apiUrl = "https://api.fostech.vn";
String idApp = "646ac3388b2b2d2d01848092";
String token = "access_token=1766b0baa43fd672a1730ac4a4ab3849";
String groupId = "646ac33c8b2b2d2d0184882a";
LocalStorage storage = LocalStorage('token');

void makingPhoneCall(String phone) async {
  var url = Uri(
    scheme: 'tel',
    path: phone,
  );
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<List> callNewsApi(String id) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/news?limit=50&q={"status":true,"category":"$id"}&$token');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callNewsApiLimit(String id, String limit) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/news?limit=$limit&q={"status":true,"category":"$id"}&$token');
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

Future<List> callAllServiceApi() async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt?limit=100&q={"is_service":true,"status":true}&$token');
  for (var data in response.data) {
    allService.add(data);
  }
  return allService;
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

Future<List> callServiceApiLimit(String id, String limit) async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt?limit=$limit&q={"ma_nvt":"$id","is_service":true,"status":true}&$token');
  for (var data in response.data) {
    allService.add(data);
  }
  return allService;
}

Future<List> callServiceApiById(String tenvt) async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt?limit=100&q={"ten_vt":"$tenvt","is_service":true,"status":true}&$token');
  for (var data in response.data) {
    allService.add(data);
  }
  return allService;
}

Future<List> callServiceApiByMVT(String mavt) async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt?limit=100&q={"ma_vt":"$mavt","is_service":true,"status":true}&$token');
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

Future<List> callProductApiByName(String tenvt) async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt?limit=100&q={"ten_vt":"$tenvt","is_service":false,"status":true}&$token');
  for (var data in response.data) {
    allService.add(data);
  }
  return allService;
}

Future<List> callProductApiByMAVT(String mavt) async {
  List allService = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/dmvt?limit=100&q={"ma_vt":"$mavt","is_service":false,"status":true}&$token');
  for (var data in response.data) {
    allService.add(data);
  }
  return allService;
}

Future<List> callProvinceApi() async {
  List allProvince = [];
  final dio = Dio();
  final response = await dio.get('https://vapi.vnappmob.com/api/province');
  for (var data in response.data["results"]) {
    allProvince.add(data);
  }
  return allProvince;
}

Future<List> callDistrictApi(String provinceId) async {
  List allProvince = [];
  final dio = Dio();
  final response = await dio
      .get('https://vapi.vnappmob.com/api/province/district/$provinceId');
  for (var data in response.data["results"]) {
    allProvince.add(data);
  }
  return allProvince;
}

Future<List> callWardApi(String districtId) async {
  List allProvince = [];
  final dio = Dio();
  final response =
      await dio.get('https://vapi.vnappmob.com/api/province/ward/$districtId');
  for (var data in response.data["results"]) {
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

Future<List> callBookingApiByTenVt(String tenvt) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio
      .get('$apiUrl/api/$idApp/tt_book?limit=100&q={"ten_vt":"$tenvt"}&$token');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callBookingApi(String phone) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/tt_book?limit=100&q={"user_created":"$phone", "status":true}&access_token=${storage.getItem("token")}');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callBookingApi1(String phone) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/tt_book?limit=100&q={"user_created":"$phone", "status":true, "dien_giai": "Đang chờ"}&access_token=${storage.getItem("token")}');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callBookingApi2(String phone) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/tt_book?limit=100&q={"user_created":"$phone", "status":true, "dien_giai": "Đã xong"}&access_token=${storage.getItem("token")}');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callBookingApi3(String phone) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/tt_book?limit=100&q={"user_created":"$phone", "status":true, "dien_giai": "Chờ trả"}&access_token=${storage.getItem("token")}');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future postBooking(Map list) async {
  // access_token=${storage.getItem("token")}
  final dio = Dio();
  final response = await dio.post(
      '$apiUrl/api/$idApp/tt_book?access_token=${storage.getItem("token")}',
      data: list);
  // print(response);
}

Future putBooking(String id, Map list) async {
  // access_token=${storage.getItem("token")}
  final dio = Dio();
  final response = await dio.put(
      '$apiUrl/api/$idApp/tt_book/$id?access_token=${storage.getItem("token")}',
      data: list);
  // print(response);
}

Future<List> callCartApi() async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/cart?limit=100&access_token=${storage.getItem("token")}');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callCartApiById(String id) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/cart/$id?limit=100&access_token=${storage.getItem("token")}');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callCartApiByName(String tenVt) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/cart?limit=100&q={"ma_vt":"$tenVt"}&access_token=${storage.getItem("token")}');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future postCart(Map list) async {
  final dio = Dio();
  final response = await dio.post(
      '$apiUrl/api/$idApp/cart?access_token=${storage.getItem("token")}',
      data: list);
  // print(response);
}

Future putCart(String id, Map list) async {
  final dio = Dio();
  final response = await dio.put(
      '$apiUrl/api/$idApp/cart/$id?access_token=${storage.getItem("token")}',
      data: list);
  return response.data;
}

Future deleteCart(String id) async {
  final dio = Dio();
  final response = await dio.delete(
      '$apiUrl/api/$idApp/cart/$id?access_token=${storage.getItem("token")}');
  // print(response);
}

Future login(String username, String password) async {}

Future signup(Map data) async {
  final dio = Dio();
  try {
    final response =
        await dio.post("https://api.fostech.vn/signup", data: data);
    print(response);
  } catch (e) {
    print(e);
  }
  // storage.dispose();
}

Future callProfile() async {
  final dio = Dio();
  final response = await dio
      .get("$apiUrl/api/profile?access_token=${storage.getItem("token")}");
  return response.data;
  // data = response;
  // storage.dispose();
}

Future getProfile(String phone) async {
  final dio = Dio();
  final response = await dio
      .get("$apiUrl/api/$idApp/customer?q={'of_user':'$phone'}&$token");
  return response.data;
  // data = response;
  // storage.dispose();
}

Future getAddress() async {
  print(storage.getItem("token"));
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      "$apiUrl/api/$idApp/customer_address?q={'status': true}&access_token=${storage.getItem("token")}");
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
  // data = response;
  // storage.dispose();
}

Future deleteAddress(String id) async {
  final dio = Dio();
  final response = await dio.delete(
      "$apiUrl/api/$idApp/customer_address/$id?q={'status': true}&access_token=${storage.getItem("token")}");
  print(response);
  // data = response;
  // storage.dispose();
}

Future postAddress(Map data) async {
  final dio = Dio();
  final response = await dio.post(
      "$apiUrl/api/$idApp/customer_address?access_token=${storage.getItem("token")}",
      data: data);
  print(response);
  // data = response;
  // storage.dispose();
}

Future putAddress(String id, Map data) async {
  final dio = Dio();
  final response = await dio.put(
      "$apiUrl/api/$idApp/customer_address/$id?access_token=${storage.getItem("token")}",
      data: data);
  print(response);
  // data = response;
  // storage.dispose();
}

Future updateProfile(String id, String phone, Map data) async {
  final dio = Dio();
  final response = await dio.put(
      "$apiUrl/api/$idApp/customer/$id?q={'of_user':'$phone'}&$token",
      data: data);
  print(response);
  // data = response;
  // storage.dispose();
}

Future callUpdateProfile(Map data) async {
  final dio = Dio();
  final response = await dio.post(
      "$apiUrl/api/updateprofile?access_token=${storage.getItem("token")}",
      data: data);
  print(response);
  // data = response;
  // storage.dispose();
}

Future changePass(Map data) async {
  final dio = Dio();
  final response = await dio.post(
      "$apiUrl/api/changepassword?access_token=${storage.getItem("token")}",
      data: data);
}

Future<List> callPBLApi(String makh) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio
      .get('$apiUrl/api/$idApp/pbl?q={"ma_kh": "$makh"}limit=100&$token');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future<List> callPBLApiStatus(String makh, String trangThai) async {
  List allNews = [];
  final dio = Dio();
  final response = await dio.get(
      '$apiUrl/api/$idApp/pbl?q={"ma_kh": "$makh", "trang_thai": "$trangThai"}&limit=100&$token');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future postPBL(Map list) async {
  final dio = Dio();
  final response = await dio.post('$apiUrl/api/$idApp/pbl?$token', data: list);
  // print(response);
}

Future putPBL(String id, Map list) async {
  final dio = Dio();
  final response =
      await dio.put('$apiUrl/api/$idApp/pbl/$id?$token', data: list);
  // print(response);
}

Future<List> callNotificationsApi() async {
  List allNews = [];
  final dio = Dio();
  final response = await dio
      .get('$apiUrl/api/notification?access_token=${storage.getItem("token")}');
  for (var data in response.data) {
    allNews.add(data);
  }
  return allNews;
}

Future postNotifications(Map data) async {
  final dio = Dio();
  final response = await dio.post(
      '$apiUrl/api/notification?access_token=${storage.getItem("token")}',
      data: data);
}

Future readNotifications(String id, Map data) async {
  final dio = Dio();
  final response = await dio.put(
      '$apiUrl/api/notification/$id?access_token=${storage.getItem("token")}',
      data: data);
}
