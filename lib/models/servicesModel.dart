import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class ServicesModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  final LocalStorage localStorageBranchs = LocalStorage("branch");
  Future<List> getGroupServiceByBranch() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Service/getGroupServiceByBranch?branchCode=001',
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

  Future<List> getHotServices() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Service/getHotService',
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

  Future<List> getServiceByBranch() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Home/getServiceByBranch?branchCode=001',
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

  Future<List> getServiceByGroup(String groupCode) async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Service/getServiceByGroup?groupServiceCode=$groupCode',
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

  Future<List> getAllServiceByGroup() async {
    List result = [];
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Service/getServiceByGroup?groupServiceCode=',
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

  Future getServiceByName(String name) async {
    try {
      Response response = await client.dio.get(
        '${client.apiUrl}/Service/getServiceByGroup?groupServiceCode=',
      );
      if (response.statusCode == 200) {
        return response.data["Data"].toList().firstWhere(
            (e) =>
                e["Name"].toString().toLowerCase() ==
                name.toString().toLowerCase(),
            orElse: () => null);
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
