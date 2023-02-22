class Product {
  dynamic id;
  late String name;
  late double value;
  late String code;

  Product({
    this.id,
    required this.name,
    required this.value,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'code': code,
    };
  }

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        value: json['value'],
        code: json['code'],
      );
}
