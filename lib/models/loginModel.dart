import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class Login {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future getOtp(String phone) async {
    print("Call: $phone");
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Customer/getOTP?PhoneNo=$phone',
      );
      print("=>>>>>>>>>>>>>>>>>>>>>>.");
      print("Response: $response");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print("Errrrrrrrrrrrrrrrrrrrrrrrrrrr: $e");
    }
  }

  Future setLogin(String phone, String otp) async {
    try {
      Response response = await client.dio.post(
        '${client.apiUrl}/Customer/setLogin?PhoneNo=$phone&OTP=$otp',
      );
      if (response.statusCode == 200) {
        localStorageCustomerToken.setItem(
            "customer_token", response.data["Data"]["Token"]);
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
