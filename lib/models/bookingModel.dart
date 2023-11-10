import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class BookingModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getBookingList() async {
    List result = [];
    try {
      Response response =
      await client.dio.get('${client.apiUrl}/Home/getBookServiceList',
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

  Future<List> getListBookinfStatus() async {
    List result = [];
    try {
      Response response =
      await client.dio.get('${client.apiUrl}/Home/getStatusBookService',
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

  Future<List> getBookingListByStatus(String status) async {
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

  Future<List> getBookingListByStatusCode(String statusCode) async {
    List result = [];
    try {
      Response response =
      await client.dio.get('${client.apiUrl}/Home/getBookServiceByStatus?Status=$statusCode',
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

  Future setBookingService(Map data) async {
    try {
      Response response =
      await client.dio.post('${client.apiUrl}/Home/setBookService',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
            '${localStorageCustomerToken.getItem("customer_token")}',
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

  Future<List> getNotifications() async {
    List result = [];
    try {
      Response response =
      await client.dio.get('${client.apiUrl}/Home/getNotification',
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
}