import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class ProfileModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future getProfile() async {
    try {
      Response response =
          await client.dio.get('${client.apiUrl}/Customer/getProfile',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        return response.data["Data"];
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future setProfile(Map data) async {
    try {
      Response response =
          await client.dio.post('${client.apiUrl}/Customer/setProfile',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future setProfileIamge(String image) async {
    try {
      Response response =
          await client.dio.post('${client.apiUrl}/Customer/setProfileImage',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: {"Image": image});
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
