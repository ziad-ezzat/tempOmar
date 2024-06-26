import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/models/userModel.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/cartModel.dart';
import '../models/drugsModel.dart';
import '../models/orderModel.dart';

class UserProvider with ChangeNotifier {
  String? token;
  User? user;
  String? userName;
  final List<Map<String, dynamic>> _drugs = [];
  List<Map<String, dynamic>> _drugsSearch = [];
  final int _totalDrugs = 0;
  int _totalDrugsSearch = 0;
  int _totalDrugsSimilar = 0;
  int _currentPage = 1;
  String query = '';
  String id ='';
  int _page = 1;
  String? message;
  CartModel? cartData;
  int? totalPrice;

  Future<void> saveToken() async
  {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'token');
    token = value;
  }

  Future<void> loadUserProfile() async {
    try {
      await saveToken();

      final dio = Dio();

      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('http://here:300/profile');
      final data = response.data;
      user = User.fromJson(data['user']);
      notifyListeners();

    } catch (e) {
      print(e);
    }
  }





  Future<List<Drug>> fetchDrugs() async {
    await saveToken();
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.get('http://here:3000/drugs?page=$_currentPage');
    if (response.statusCode == 200) {
      final drugs = List<Map<String, dynamic>>.from(response.data['drugs']);
      return drugs.map((drug) => Drug(
        name: drug['name'] as String,
        activeIngredient: drug['activeIngredient'] as String,
        price: (drug['price'] as num).toDouble(),
        id:  drug['_id'] as String,
        category: '',
      )).toList();
    } else {
      throw Exception('Failed to fetch drugs');
    }
  }



  List<Map<String, dynamic>> get drugs => _drugs;
  int get totalDrugs => _totalDrugs;
  int get currentPage => _currentPage;


  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  void previousPage() {
    if (_currentPage > 1) {
      currentPage--;
      fetchDrugs();
    }
  }

  void nextPage() {
    if ((_currentPage - 1) * 10 < _totalDrugs) {
      currentPage++;
      fetchDrugs();
    }
  }


  Future<void> searchDrugs(String query, int page) async {
    try {
      await saveToken();
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get("http://here:3000/search?search=$query&page=$page");
      if (response.statusCode == 200) {
        _drugsSearch = List<Map<String, dynamic>>.from(response.data['drugs']);
        _totalDrugsSearch = response.data['totalDrugs'];
        _page = page;
        notifyListeners();
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw message = ('Invalid Drug');
      }
    }
  }


  List<Map<String, dynamic>> get drugsSearch => _drugsSearch;
  int get totalDrugsSearch => _totalDrugsSearch;
  int get page => _page;

  Future<void> nextPageSearch(String query) async {
    if (_drugsSearch.length < _totalDrugsSearch) {
      final nextPage = _page + 1;
      await searchDrugs(query, nextPage);
    }
  }

  Future<void> previousPageSearch(String query) async {
    if (_page > 1) {
      final previousPage = _page - 1;
      await searchDrugs(query, previousPage);
    }
  }


  Future<Map<String, dynamic>> getDrugDetails(String id) async {
    try {
      await saveToken();
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get("http://here:3000/drug/$id");
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['drug']);
      } else {
        throw Exception("Failed to get drug details.");
      }
    } catch (e) {
      throw Exception("Failed to get drug details.");
    }
  }



  Future<List<Drug>> getSimilarDrugs(String id, int similarPage) async {
    try {
      final response = await Dio().get('http://here:3000/similarDrugs/$id?page=$similarPage');
      final data = response.data['similarDrugs'] as List<dynamic>;
      _totalDrugsSimilar = response.data['totalDrugs'];
      final drugs = data.map((item) => Drug.fromJson(item)).toList();
      return drugs;
    } catch (error) {
      print('Error fetching similar drugs: $error');
      rethrow;
    }
  }

  List<Drug> _similarDrugs = [];
  int _similarPage = 1;
  int get totalDrugsSimilar => _totalDrugsSimilar;
  List<Drug> get similarDrugs => _similarDrugs;
  int get similarPage => _similarPage;

  Future<void> nextPageSimilar(String id) async {
    final drugs = await getSimilarDrugs(id, _similarPage + 1);
    if (drugs.isNotEmpty) {
      _similarDrugs = drugs;
      _similarPage++;
    }
  }

  Future<void> previousPageSimilar(String id) async {
    if (_similarPage > 1) {
      final drugs = await getSimilarDrugs(id, _similarPage - 1);
      _similarDrugs = drugs;
      _similarPage--;
    }
  }


  Future<Map<String, dynamic>> fetchCartData() async {
    try {
      await saveToken();

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get('http://here:3000/cart');
      final data = response.data;

      if (data != null) {
        final responseData = ResponseModel.fromJson(data);
        final cartData = responseData.cart;
        final totalPrice = responseData.totalPrice;
        notifyListeners();

        return {
          'cartData': cartData,
          'totalPrice': totalPrice,
        };
      } else {
        throw Exception('Success');
      }
    } catch (e) {
      print('Empty');
      rethrow;
    }
  }




  Future<void> deleteDrugFromCart(String drugId) async {
    await saveToken();

    final dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $token';

    final url = 'http://here:3000/cart/removeItem/$drugId';

    try {
      final response = await dio.delete(url);

      if (response.statusCode == 200) {

      } else {

        print('Failed to delete the drug from the cart. Status code: ${response.statusCode}');
      }
    } catch (error) {

      print('Failed to delete the drug from the cart: $error');
    }
  }



  Future<List<Order>> fetchOrders() async {
    final dio = Dio();

    await saveToken();
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get('http://here:3000/order/Orders');
      final orders = response.data['orders'];

      List<Order> orderList = [];
      for (var order in orders) {
        orderList.add(Order(
          id: order['_id'],
          phone: order['phone'],
          shippingAddress: order['shippingAddress'],
          paymentMethod: order['paymentMethod'],
          status: order['status'],
          totalPrice: order['totalPrice'],
        ));
      }

      return orderList;
    } catch (error) {
      print('Error fetching orders: $error');
      return [];
    }
  }

  Future<void> deleteOrder(String cartId) async {
    await saveToken();

    final dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $token';

    final url = 'http://here:3000/order/cancelOrder/$cartId';

    try {
      final response = await dio.delete(url);

      if (response.statusCode == 200) {

      } else {

        print('Failed to delete the Order. Status code: ${response.statusCode}');
      }
    } catch (error) {

      print('Failed to delete the drug Order: $error');
    }
  }

  Future<void> deleteAllHistory() async {

    await saveToken();
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    final url = 'http://here:3000/deleteAllHistory';

    try {
      final response = await dio.delete(url);

      if (response.statusCode == 200) {
        print('History deleted successfully.');
      } else {
        print('Failed to delete history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting history: $e');
    }
  }

  Future<void> addToCart(String drugId, int quantity) async {
    await saveToken();
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      var url = 'http://here:3000/cart/addToCart/$drugId';
      var response = await dio.post(
        url,
        data: {
          "quantity": quantity,
        },
      );
      if (response.statusCode == 200) {
        print('Drug added to cart successfully!');
      } else {
        print('Failed to add drug to cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> checkout(String shippingAddress, String phone, String paymentMethod) async {
    try {
      await saveToken();

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      Response response = await dio.post(
        'http://here:3000/order/checkout',
        data: {
          'shippingAddress': shippingAddress,
          'phone':phone,
          'paymentMethod':paymentMethod
      },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);

      } else {
        print('Error: ${response.statusCode}');
      }
    } on DioError catch(e)
    {

      if(e.response!=null)
      {
        print(e.response!.data.toString());
      }
      else if (e.error is SocketException) {
        print(e.message.toString());
      }else if (e.error is TimeoutException) {
        print(e.message.toString());
      }
      else
      {
        print(e.message.toString());
      }
      rethrow;



    }
  }



  Future<void> updateUserName(String newUserName) async {

    const url = 'http://here:3000/editUser';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = {
      'userName': newUserName,
    };
    try {
      final response = await Dio().put(url, data: data, options: Options(headers: headers));

      if (response.statusCode == 200) {
        userName = newUserName;
        notifyListeners();
      } else {
        throw Exception('Failed to update username.');
      }
    } catch (error) {
      rethrow;
    }
  }





// Future<void> setUser()async
// {
//   await SaveToken();
//   // List<String>? tokenParts = token?.split('.');
//   // String header = tokenParts![0];
//   // String payload = tokenParts[1];
//   // String signature = tokenParts[2];
//   //
//   // String decodedPayload = utf8.decode(base64Url.decode(payload));
//   // Map<String, dynamic> payloadMap = json.decode(decodedPayload);
//
//
//    user=User(
//
//       userId: payloadMap['userId'],
//      createdAt: payloadMap['createdAt'],
//       userName: payloadMap['userName'],
//       role: payloadMap['role'],
//       email:payloadMap['email'],
//
//   );
//
//
//
// }


    Future<void> logOut() async {
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'token');
    }



}