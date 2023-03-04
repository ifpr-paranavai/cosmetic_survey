class OrderProducts {
  dynamic id;
  late int quantity;
  late double orderPrice;

  OrderProducts({
    this.id,
    required this.quantity,
    required this.orderPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'orderPrice': orderPrice,
    };
  }

  static OrderProducts fromJson(Map<String, dynamic> json) => OrderProducts(
        id: json['id'],
        quantity: json['quantity'],
        orderPrice: json['orderPrice'],
      );
}
