class OrderProducts {
  dynamic id;
  late int quantity;
  late double price;
  dynamic orderId;
  dynamic productId;

  OrderProducts({
    this.id,
    required this.quantity,
    required this.price,
    required this.orderId,
    required this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'orderId': orderId,
      'productId': productId,
    };
  }

  static OrderProducts fromJson(Map<String, dynamic> json) => OrderProducts(
        id: json['id'],
        quantity: json['quantity'],
        price: json['price'],
        orderId: json['orderId'],
        productId: json['productId'],
      );
}
