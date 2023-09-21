import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class MemberModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  Future getRank(String name) async {
    try {
      Response response =
          await client.dio.get('${client.apiUrl}/CustomerLevel/GetCustomerLevelDetail?Code=$name',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        return response.data["Data"][0];
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
