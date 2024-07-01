import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/models/userModel.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<void> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersData = prefs.getString('ordersData');
    if (ordersData != null) {
      _orders = (jsonDecode(ordersData) as List)
          .map((data) => Order.fromJson(data))
          .toList();
      notifyListeners();
    }
  }

  Future<void> addOrder(Order order) async {
    _orders.add(order);
    await _saveOrdersToLocalStorage();
    notifyListeners();
  }

  Future<void> deleteOrder(String orderId) async {
    _orders.removeWhere((order) => order.id == orderId);
    await _saveOrdersToLocalStorage();
    notifyListeners();
  }

  Future<void> _saveOrdersToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersData = jsonEncode(_orders.map((order) => order.toJson()).toList());
    prefs.setString('ordersData', ordersData);
  }
  
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
      final response = await dio.get('http://192.168.1.20:3000/profile');
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

    final response = await dio.get('http://192.168.1.20:3000/drugs?page=$_currentPage');
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

      final response = await dio.get("http://192.168.1.20:3000/search?search=$query&page=$page");
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

      final response = await dio.get("http://192.168.1.20:3000/drug/$id");
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
      final response = await Dio().get('http://192.168.1.20:3000/similarDrugs/$id?page=$similarPage');
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

  // Future<void> nextPageSimilar(String id) async {
  //   final drugs = await getSimilarDrugs(id, _similarPage + 1);
  //   if (drugs.isNotEmpty) {
  //     _similarDrugs = drugs;
  //     _similarPage++;
  //   }
  // }

  // Future<void> previousPageSimilar(String id) async {
  //   if (_similarPage > 1) {
  //     final drugs = await getSimilarDrugs(id, _similarPage - 1);
  //     _similarDrugs = drugs;
  //     _similarPage--;
  //   }
  // }

  Future<void> deleteAllHistory() async {

    await saveToken();
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    final url = 'http://192.168.1.20:3000/deleteAllHistory';

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

  Future<void> updateUserName(String newUserName) async {

    const url = 'http://192.168.1.20:3000/editUser';
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



    Future<void> logOut() async {
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'token');
    }

}