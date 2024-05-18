import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class CheckInModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getCheckInList() async {
    List result = [];
    try {
      Response response = await client.dio.get(
          '${client.apiUrl}/Customer/getCheckIn',
          // .get('${client.goodAppUrl}/checkin?access_token=${client.token}',
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

  Future addCheckIn(Map data) async {
    try {
      Response response =
          await client.dio.post('${client.apiUrl}/Customer/postCheckIn',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: data);
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future userUsingCoin(int coin) async {
    try {
      Response response =
          await client.dio.post('${client.apiUrl}/Customer/usingCustomerCoin',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: {"Coin": coin});
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> getMission() async {
    List result = [];
    try {
      Response response = await client.dio.get(
          '${client.apiUrl}/Customer/getMission',
          // .get('${client.goodAppUrl}/checkin?access_token=${client.token}',
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

  Future<List> getMissionByStatus(String status) async {
    List result = [];
    try {
      Response response = await client.dio.get(
          '${client.apiUrl}/Customer/getMission',
          // .get('${client.goodAppUrl}/checkin?access_token=${client.token}',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                '${localStorageCustomerToken.getItem("customer_token")}',
          }));
      if (response.statusCode == 200) {
        print(response.data["Data"]);
        for (var item in response.data["Data"]) {
          if (item["Status"].toString().toLowerCase() == status.toLowerCase()) {
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

  Future collectMission(int id) async {
    List result = [];
    try {
      Response response = await client.dio.post(
          '${client.apiUrl}/Customer/collectMission?coinMissionId=$id',
          // .get('${client.goodAppUrl}/checkin?access_token=${client.token}',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                '${localStorageCustomerToken.getItem("customer_token")}',
          }),
          data: {});
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future completedMission(int id) async {
    List result = [];
    try {
      Response response = await client.dio.post(
          '${client.apiUrl}/Customer/completedMission?coinMissionId=$id',
          // .get('${client.goodAppUrl}/checkin?access_token=${client.token}',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                '${localStorageCustomerToken.getItem("customer_token")}',
          }),
          data: {});
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List> getReceiptHistory() async {
    List result = [];
    try {
      Response response = await client.dio.get(
          '${client.apiUrl}/Customer/coinReceiptHistory',
          // .get('${client.goodAppUrl}/checkin?access_token=${client.token}',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                '${localStorageCustomerToken.getItem("customer_token")}',
          }));
      if (response.statusCode == 200) {
        print(response.data["Data"]);
        return result = response.data["Data"];
      } else {
        return result;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List> getUsageHistory() async {
    List result = [];
    try {
      Response response = await client.dio.get(
          '${client.apiUrl}/Customer/coinUsageHistory',
          // .get('${client.goodAppUrl}/checkin?access_token=${client.token}',
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
