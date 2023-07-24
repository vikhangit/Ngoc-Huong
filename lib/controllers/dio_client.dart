import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ngoc_huong/models/banner.dart';

class DioClient {
  final Dio _dio = Dio();
  final String apiUrl = "https://api.fostech.vn";
  final String idApp = "646ac3388b2b2d2d01848092";
  final String token = "access_token=1766b0baa43fd672a1730ac4a4ab3849";
  final String groupId = "646ac33c8b2b2d2d0184882a";
}
