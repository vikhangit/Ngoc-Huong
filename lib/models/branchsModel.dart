import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class BranchsModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getBranchs() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Branch/getBranchs',
        // options: Options(headers: {
        //   'Content-Type': 'application/json; charset=UTF-8',
        //   'Authorization':
        //       '${localStorageCustomerToken.getItem("customer_token")}',
        // })
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
  Future getBranchDetails(String code) async {
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Branch/getBranchDetail?Code=$code',
        // options: Options(headers: {
        //   'Content-Type': 'application/json; charset=UTF-8',
        //   'Authorization':
        //       '${localStorageCustomerToken.getItem("customer_token")}',
        // })
      );
      if (response.statusCode == 200) {
        return response.data["Data"];
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
