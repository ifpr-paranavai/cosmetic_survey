class Product {
  dynamic id;
  late String name;
  late double price;
  late int code;
  late dynamic brandId;
  late DateTime? creationTime;
  late int? quantity;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.code,
    required this.brandId,
    this.creationTime,
    this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'code': code,
      'brandId': brandId,
      'creationTime': creationTime,
      'quantity': quantity,
    };
  }

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        code: json['code'],
        brandId: json['brandId'],
        creationTime: json['creationTime'].toDate(),
        quantity: json['quantity'],
      );
}
