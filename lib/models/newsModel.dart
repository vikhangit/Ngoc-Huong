import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class NewsModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getTop5CustomerNews() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Home/getTop5CustomerNews',
      );
      if (response.statusCode == 200) {
        return result = response.data["Data"];
      } else {
        return result;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List> getAllCustomerNews() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '$goodAppUrl/api/$idApp/news?$token',
      );
      if (response.statusCode == 200) {
        return result = response.data;
      } else {
        return result;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List> getCustomerNewsByGroup(String groupCode) async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/CustomerNews/getNewsByGroup?groupNews=$groupCode',
      );
      if (response.statusCode == 200) {
        return result = response.data["Data"];
      } else {
        return result;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }
}
