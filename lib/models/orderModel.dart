class Order {
  final String id;
  final String phone;
  final String shippingAddress;
  final String paymentMethod;
  final String status;
  final int totalPrice;

  Order({
    required this.id,
    required this.phone,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.status,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      phone: json['phone'],
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      totalPrice: json['totalPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'status': status,
      'totalPrice': totalPrice,
    };
  }
}