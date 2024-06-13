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

  Future<List> getStatusList() async {
    List result = [];
    try {
      Response response = await client.dio
          .get('${client.apiUrl}/ProductInvoice/getProductInvoiceStatus',
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

  Future<Map> getStatusByCode(String code) async {
    Map result = {};
    try {
      Response response = await client.dio
          .get('${client.apiUrl}/ProductInvoice/getProductInvoiceStatus',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        return result = response.data["Data"].toList().firstWhere(
            (e) =>
                e["GroupCode"].toString().toLowerCase() ==
                code.toString().toLowerCase(),
            orElse: () => null);
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
      Response response = await client.dio
          .get('${client.apiUrl}/ProductInvoice/getProductInvoiceByCustomer',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    // 'ajl6c2xnSTNkNCtYbnJ1NmdjSjFlN2Z2azhGSGp0ZkRyUjFsOHpmR2F1eXlyY0VaOUFSZGdBPT0='
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

  Future<List> getAllOrderList() async {
    List result = [];
    try {
      Response response = await client.dio
          .get('${client.apiUrl}/ProductInvoice/getProductInvoiceByCustomer',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    // 'ajl6c2xnSTNkNCtYbnJ1NmdjSjFlN2Z2azhGSGp0ZkRyUjFsOHpmR2F1eXlyY0VaOUFSZGdBPT0='
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

  Future<List> getMyOrderListByStatus(String status) async {
    List result = [];
    try {
      Response response =
          await client.dio.get('${client.apiUrl}/ProductInvoice/getOrderList',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    // 'ajl6c2xnSTNkNCtYbnJ1NmdjSjFlN2Z2azhGSGp0ZkRyUjFsOHpmR2F1eXlyY0VaOUFSZGdBPT0='
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
        return response.data["Data"];
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future putStatusOrder(int id, String status) async {
    try {
      Response response = await client.dio.put(
          '${client.apiUrl}/ProductInvoice/putOrderStatus?Id=$id&Status=$status',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                '${localStorageCustomerToken.getItem("customer_token")}',
          }));
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
