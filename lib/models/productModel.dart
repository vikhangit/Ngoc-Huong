import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class ProductModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getAllProduct() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Product/getAllProduct',
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
  Future<List> getGroupProduct() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Product/getGroupProduct',
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

  Future<List> getProductByGroup(String groupCode) async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Product/getProductByGroup?groupCode=$groupCode',
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

  Future<Map> getProductCode(String code) async {
    Map result = {};
    try {
      Response response =
      await client.dio.get('${client.apiUrl}/Product/getAllProduct',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
            '${localStorageCustomerToken.getItem("customer_token")}',
          })
      );
      if (response.statusCode == 200) {
        return result = response.data["Data"].toList().firstWhere((e) => e["Code"]
            .toString()
            .toLowerCase() == code.toString().toLowerCase(), orElse: () => null);
      } else {
        return result;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }


  Future<List> getHotProduct() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Product/getHotProduct',
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
