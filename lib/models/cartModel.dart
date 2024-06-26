class UserModel {
  String email;
  String userName;

  UserModel({
    required this.email,
    required this.userName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      userName: json['userName'],
    );
  }
}

class DrugModel {
  String name;

  DrugModel({
    required this.name,
  });

  factory DrugModel.fromJson(Map<String, dynamic> json) {
    return DrugModel(
      name: json['name'],
    );
  }
}

class CartItemModel {
  DrugModel drug;
  int quantity;
  int price;
  String id;

  CartItemModel({
    required this.drug,
    required this.quantity,
    required this.price,
    required this.id,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      drug: DrugModel.fromJson(json['drug']),
      quantity: json['quantity'],
      price: json['price'],
      id: json['_id'],
    );
  }
}

class CartModel {
  String id;
  UserModel user;
  List<CartItemModel> items;
  DateTime createdAt;

  CartModel({
    required this.id,
    required this.user,
    required this.items,
    required this.createdAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'],
      user: UserModel.fromJson(json['user']),
      items: List<CartItemModel>.from(
        json['items'].map((item) => CartItemModel.fromJson(item)),
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ResponseModel {
  String message;
  CartModel cart;
  int totalPrice;

  ResponseModel({
    required this.message,
    required this.cart,
    required this.totalPrice,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: json['Message'],
      cart: CartModel.fromJson(json['cart']),
      totalPrice: json['totalPrice'],
    );
  }
}
