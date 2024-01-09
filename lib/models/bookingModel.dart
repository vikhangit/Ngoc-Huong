import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class BookingModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getBookingList() async {
    List result = [];
    try {
      Response response = await client.dio
          .get('${client.apiUrl}/Home/getAllBookServiceByCustomer',
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

  Future<List> getUsingBooking() async {
    List result = [];
    try {
      Response response = await client.dio
          .get('${client.apiUrl}/Question/getAllUsingServiceCustomer',
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
      Response response = await client.dio
          .get('${client.apiUrl}/Home/getAllBookServiceByCustomer',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    // 'ajl6c2xnSTNkNCtYbnJ1NmdjSjFlN2Z2azhGSGp0ZkRyUjFsOHpmR2F1eXlyY0VaOUFSZGdBPT0='
                '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        // for (int i = 0; i < response.data["Data"].length; i++) {
        //   if (response.data["Data"][i]["Status"] == statusCode) {
        //     result.add(response.data["Data"][i]);
        //   }
        // }
        return result = response.data["Data"]
            .where((e) =>
                e["Status"].toString() == statusCode &&
                e["serviceList"][0]["Type"] == "service")
            .toList();
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

  Future putBookingService(Map data) async {
    try {
      Response response =
          await client.dio.put('${client.apiUrl}/Home/putBookService',
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

  Future cancelBookingService(Map data) async {
    try {
      Response response =
          await client.dio.put('${client.apiUrl}/Home/putBookService',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: {...data, "Status": "cancel"});
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

  Future readNotifications(int id) async {
    try {
      Response response = await client.dio
          .put('${client.apiUrl}/Home/putReadNotification?Id=$id',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }));
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
