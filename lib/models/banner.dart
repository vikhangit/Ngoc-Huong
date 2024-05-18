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
      Response response = await client.dio
          .get('$goodAppUrl/api/$idApp/voucher.ngochuong?$token',
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

  Future<Map> getVoucherByMaVoucher(String maVoucher) async {
    Map result = {};
    try {
      Response response = await client.dio
          .get('$goodAppUrl/api/$idApp/voucher.ngochuong?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        return result = response.data
            .toList()
            .firstWhere((e) => e["ma"] == maVoucher, orElse: () => null);
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

  Future<List> getVoucherBuy(String phone) async {
    List result = [];
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/hd1.voucher.nh?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        for (var item in response.data) {
          if (item["ma_kh"].toString() == phone.toString()) {
            result.add(item);
          }
        }
        return result;
      } else {
        return result;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<Map> getVoucherBuyWithMaVoucher(String phone, String maVoucher) async {
    List result = [];
    Map dl = {};
    try {
      Response response =
          await client.dio.get('$goodAppUrl/api/$idApp/hd1.voucher.nh?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        for (var item in response.data) {
          if (item["ma_kh"].toString() == phone.toString()) {
            result.add(item);
          }
        }
        print(result);
        return dl = result.firstWhere(
            (e) => e["details"][0]["ma_evoucher"] == maVoucher,
            orElse: () => null);
      } else {
        return dl;
      }
    } catch (e) {
      print(e);
    }
    return dl;
  }

  Future addVoucherBuy(Map data) async {
    try {
      Response response =
          await client.dio.post('$goodAppUrl/api/$idApp/hd1.voucher.nh?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
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

  Future editVoucherBuy(String id, Map data) async {
    try {
      Response response = await client.dio
          .put('$goodAppUrl/api/$idApp/hd1.voucher.nh/$id?$token',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: data);
      if (response.statusCode == 200) {
        print(response);
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
