import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class RatingrModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getQuestionList() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/startquote?$token',
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

  Future<List> getRatingList() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/startquote.data?$token',
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

  Future addRatingForUser(Map data) async {
    try {
      Response response =
          await client.dio.post('$goodAppUrl/api/$idApp/startquote.data?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: data);
      if (response.statusCode == 200) {
        print("=====");
        print(response.data);
        print("=====");
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
