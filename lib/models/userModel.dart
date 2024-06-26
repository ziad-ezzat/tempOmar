class User {
  String email;
  String userName;
  List<Map<String, dynamic>> searchHistory;
  List<Map<String, dynamic>> orderHistory;
  String role;
  DateTime createdAt;

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        userName = json['userName'],
        searchHistory = List<Map<String, dynamic>>.from(json['searchHistory']),
        orderHistory = List<Map<String, dynamic>>.from(json['orderHistory']),
        role = json['role'],
        createdAt = DateTime.parse(json['createdAt']) {
    if (json['orderHistory'] != null) {
      orderHistory = List<Map<String, dynamic>>.from(json['orderHistory'])
          .map((order) => {
        '_id': order['_id'],
        'totalPrice': order['totalPrice'],
        'phone': order['phone'],
        'shippingAddress': order['shippingAddress'],
        'paymentMethod': order['paymentMethod'],
        'status': order['status'],
        'items': List<Map<String, dynamic>>.from(order['items'])
            .map((item) => {
          'drug': item['drug'],
          'quantity': item['quantity'],
          'price': item['price'],
          '_id': item['_id'],
        })
            .toList(),
        'createdAt': order['createdAt'],
      })
          .toList();
    }
  }
}
