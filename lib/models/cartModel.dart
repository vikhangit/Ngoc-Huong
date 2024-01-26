import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/controllers/dio_client.dart';

class CartModel {
  final DioClient client = DioClient();
  final LocalStorage localStorageCustomerToken = LocalStorage("customer_token");
  final LocalStorage localStorageCustomerCart = LocalStorage("customer_cart");
  // Future addProductToCart(Map product) async {
  //   List products = localStorageCustomerCart.getItem("customer_cart") != null
  //       ? jsonDecode(localStorageCustomerCart.getItem("customer_cart"))
  //       : [];
  //   if (products.isEmpty) {
  //     products.insert(0, product);
  //   } else {
  //     int index =
  //         products.indexWhere((element) => element["Code"] == product["Code"]);
  //     if (index < 0) {
  //       products.insert(0, product);
  //     } else {
  //       print("Product Quantity: ${product["quantity"]}");
  //       products[index]["quantity"] =
  //           products[index]["quantity"] + product["quantity"];
  //     }
  //   }
  //   localStorageCustomerCart.setItem("customer_cart", jsonEncode(products));
  // }

  Future<List> getProductCartList() async {
    List result = [];
    try {
      Response response =
          await client.dio.get('${client.apiUrl}/ShoppingCart/getAddToCart',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        print(
            "<ee>=============================================================================<ee>");
        print(localStorageCustomerToken.getItem("customer_token"));
        return result = response.data["Data"];
      } else {
        return result;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future getDetailCart(int cartId) async {
    try {
      Response response = await client.dio.get(
          '${client.apiUrl}//ShoppingCart/getDetailAddToCart?ShoppingCartId=$cartId',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                '${localStorageCustomerToken.getItem("customer_token")}',
          }));
      if (response.statusCode == 200) {
        return response.data["Data"];
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map> getDetailCartByCode(String code) async {
    Map result = {};
    try {
      Response response =
          await client.dio.get('${client.apiUrl}/ShoppingCart/getAddToCart',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }));
      if (response.statusCode == 200) {
        return result = response.data["Data"].toList().firstWhere(
            (e) =>
                e["ProductCode"].toString().toLowerCase() ==
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

  Future addToCart(Map data) async {
    try {
      Response response =
          await client.dio.post('${client.apiUrl}/ShoppingCart/AddToCart',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: data);
      if (response.statusCode == 200) {
        print(
            "<ee>=============================================================================<ee>");
        print(response);
        return response.data["Data"];
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateProductInCart(Map data) async {
    try {
      Response response =
          await client.dio.put('${client.apiUrl}/ShoppingCart/putShoppingCart',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: data);
      if (response.statusCode == 200) {
        print(response);
        return response.data["Data"];
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateProductToCart(Map product) async {
    try {
      Response response =
          await client.dio.post('${client.apiUrl}/ShoppingCart/putShoppingCart',
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    '${localStorageCustomerToken.getItem("customer_token")}',
              }),
              data: product);
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
