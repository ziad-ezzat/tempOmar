import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation_project/models/cartModel.dart';

class CartProvider with ChangeNotifier {
  CartModel? _cart;

  CartModel? get cart => _cart;

  CartProvider() {
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cartData');
    if (cartData != null) {
      _cart = CartModel.fromJson(jsonDecode(cartData));
      notifyListeners();
    }
  }

  Future<void> addToCart(DrugModel drug, int quantity, int price) async {
    final newItem = CartItemModel(
      drug: drug,
      quantity: quantity,
      price: price, // Assuming fixed price for now
      id: DateTime.now().toString(),
    );

    if (_cart == null) {
      _cart = CartModel(
        id: DateTime.now().toString(),
        user: UserModel(email: 'user@example.com', userName: 'User'), // Dummy user
        items: [newItem],
        createdAt: DateTime.now(),
      );
    } else {
      _cart!.items.add(newItem);
    }

    await _saveCartToLocalStorage();
    notifyListeners();
  }

  Future<void> deleteDrugFromCart(String drugId) async {
    _cart?.items.removeWhere((item) => item.id == drugId);
    await _saveCartToLocalStorage();
    notifyListeners();
  }

  double get totalPrice {
    return _cart?.items.fold(0, (sum, item) => sum! + (item.price * item.quantity)) ?? 0;
  }

  Future<void> _saveCartToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = jsonEncode(_cart?.toJson());
    prefs.setString('cartData', cartData);
  }

  Future<void> checkout(String shippingAddress, String phone, String paymentMethod) async {
    
      print('checkout');
      print('shippingAddress: $shippingAddress');
      print('phone: $phone');
      print('paymentMethod: $paymentMethod');

      cart?.items.clear();
      await _saveCartToLocalStorage();
      notifyListeners();
  }
}