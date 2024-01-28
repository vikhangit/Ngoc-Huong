import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class AppInfoModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<Map> getAppInfo() async {
    Map result = {};
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/app/$idApp?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }));
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

  Future<List> getAboutUs(String text) async {
    List result = [];
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/info.$text?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }));
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

  Future<List> getPo() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/info.intro?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }));
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
}
