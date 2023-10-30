import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class AddressModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getCustomerAddress() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('${client.apiUrl}/CustomerAddress/getCustomerAddress',
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

  Future<List> getProvinceApi(String provinceName) async {
    List result = [];
    try {
      Response response =
      await client.dio.get('${client.apiUrl}/Home/getProvince?searchName=$provinceName',
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

  Future<List> getDistrictApi(String parentId, String districtName) async {
    List result = [];
    try {
      Response response =
      await client.dio.get('${client.apiUrl}/Home/getDistrict?ParentId=$parentId&searchName=$districtName',
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

  Future<List> getWardApi(String parentId, String wardName) async {
    List result = [];
    try {
      Response response =
      await client.dio.get('${client.apiUrl}/Home/getWard/?ParentId=$parentId&searchName=$wardName',
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

  Future setNewCustomerAddress(Map data) async {
    try {
      Response response =
          await client.dio.post('${client.apiUrl}/CustomerAddress/setCustomerAddress',
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

  Future updateCustomerAddress(Map data) async {
    try {
      Response response =
      await client.dio.put('${client.apiUrl}/CustomerAddress/putCustomerAddress',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
            '${localStorageCustomerToken.getItem("customer_token")}',
          }),
          data: data);
      if (response.statusCode == 200) {
        print("---------------------------------------");
        print(response.data);
        print("---------------------------------------");
        return response.data;
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteCustomerAddress(int id) async {
    try {
      Response response =
      await client.dio.delete('${client.apiUrl}/CustomerAddress/deleteCustomerAddress?Id=$id',
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
