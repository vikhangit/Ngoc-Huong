import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class CheckInModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future<List> getCheckInList() async {
    List result = [];
    try {
      Response response = await client.dio
          .get('${client.goodAppUrl}/checkin?access_token=${client.token}',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                // 'Authorization':
                //     '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        return result = response.data;
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
      Response response = await client.dio
          .post('${client.goodAppUrl}/checkin?access_token=${client.token}',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
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
}
