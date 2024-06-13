import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class RatingrModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getQuestionList() async {
    List result = [];
    try {
      Response response = await client.dio
          .get('$goodAppUrl/api/$idApp/starquote_question?$token');
      if (response.statusCode == 200) {
        print("=====");
        print(response.data);
        print("=====");
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
          await client.dio.get('$goodAppUrl/api/$idApp/startquote?$token');
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
    print("=====");
    print(data);
    print("=====");
    try {
      Response response = await client.dio
          .post('$goodAppUrl/api/$idApp/starquote?$token', data: data);
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
