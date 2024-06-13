import 'package:dio/dio.dart';

String token = "access_token=54780e1dc7d2a78f168e3036acae0dc0";
String idApp = "66695bb9a8cfc30cdbbebc65";
String goodAppUrl = "https://api135.goodapp.vn";

class DioClient {
  final Dio dio = Dio();
  final String apiUrl = "http://api_ngochuong.osales.vn/api";
  final String token = "54780e1dc7d2a78f168e3036acae0dc0";
  final String goodAppUrl =
      "https://api135.goodapp.vn/api/66695bb9a8cfc30cdbbebc65";
}
