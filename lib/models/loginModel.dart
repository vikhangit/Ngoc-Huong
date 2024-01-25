import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';
import 'package:ngoc_huong/screen/profile/profile_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';

class Login {
  final DioClient client = DioClient();
  final CustomModal customModal = CustomModal();
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

  Future setLogin(BuildContext context, String phone, String otp) async {
    try {
      Response response = await client.dio.post(
        '${client.apiUrl}/Customer/setLogin?PhoneNo=$phone&OTP=$otp',
      );
      if (response.statusCode == 200) {
        localStorageCustomerToken.setItem(
            "customer_token", response.data["Data"]["Token"]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(
                      phone: phone.toString(),
                    )));
        return response.data;
      } else {
        customModal.showAlertDialog(
            context,
            "error",
            "Lỗi xác thực",
            "Mã xác thực otp không đúng!",
            () => Navigator.of(context).pop(),
            () => Navigator.of(context).pop());
        return;
      }
    } catch (e) {
      customModal.showAlertDialog(
          context,
          "error",
          "Lỗi xác thực",
          "Mã xác thực otp không đúng!",
          () => Navigator.of(context).pop(),
          () => Navigator.of(context).pop());
    }
  }
}
