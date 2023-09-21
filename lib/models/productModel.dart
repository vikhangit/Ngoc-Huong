import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class ProductModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
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
