import 'package:dio/dio.dart';

String token = "access_token=028e7792d98ffa9234c1eb257b0f0a22";
String idApp = "654ee7094ddf99289bf89a8b";
String goodAppUrl = "https://api.goodapp.vn";

class DioClient {
  final Dio dio = Dio();
  final String apiUrl = "http://api_ngochuong.osales.vn/api";
  final String token = "028e7792d98ffa9234c1eb257b0f0a22";
  final String goodAppUrl =
      "https://api.goodapp.vn/api/654ee7094ddf99289bf89a8b";
}
