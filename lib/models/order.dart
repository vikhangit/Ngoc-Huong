import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class OrderModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getOrderList() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('${client.apiUrl}/ProductInvoice/getOrderList',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }));
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

  Future<List> getOrderListByStatus(String status) async {
    List result = [];
    try {
      Response response =
          await client.dio.get('${client.apiUrl}/ProductInvoice/getOrderList',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        for (var item in response.data["Data"]) {
          if (item["Status"] == status) {
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

  Future setOrder(Map data) async {
    try {
      Response response =
          await client.dio.post('${client.apiUrl}/ProductInvoice/setOrder',
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
}
