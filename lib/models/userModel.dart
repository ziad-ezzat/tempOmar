import 'package:graduation_project/models/orderModel.dart';

class User {
  final String id;
  final String userName;
  final String email;
  final DateTime createdAt;
  final String role;
  final List<Order> orderHistory;
  final List<String> searchHistory;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.createdAt,
    required this.role,
    required this.orderHistory,
    required this.searchHistory,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      role: json['role'],
      orderHistory: (json['orderHistory'] as List).map((order) => Order.fromJson(order)).toList(),
      searchHistory: List<String>.from(json['searchHistory']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
      'orderHistory': orderHistory.map((order) => order.toJson()).toList(),
      'searchHistory': searchHistory,
    };
  }

  User copyWith({
    String? id,
    String? userName,
    String? email,
    DateTime? createdAt,
    String? role,
    List<Order>? orderHistory,
    List<String>? searchHistory,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      orderHistory: orderHistory ?? this.orderHistory,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }
}