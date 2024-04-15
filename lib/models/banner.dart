import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class BannerModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getBannerList() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/mobilelib?$token',
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

  Future<List> getFlashSale() async {
    List result = [];
    try {
      Response response = await client.dio
          .get('$goodAppUrl/api/$idApp/ecompromotion_flashsales?$token',
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

  Future<List> getVoucher() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/voucher.infoapp?$token',
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

  Future<List> getReviewServices() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/service.review?$token',
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
