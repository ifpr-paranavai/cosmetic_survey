class Product {
  dynamic id;
  late String name;
  late double price;
  late int code;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'code': code,
    };
  }

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        code: json['code'],
      );
}
