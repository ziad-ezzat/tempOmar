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
}
