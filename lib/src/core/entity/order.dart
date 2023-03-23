

class CosmeticOrder {
  dynamic id;

  // late List<Product> products = <Product>[];
  late int cicle;
  late DateTime? saleDate;

  CosmeticOrder({
    this.id,
    // required this.products,
    required this.cicle,
    this.saleDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'products': products,
      'cicle': cicle,
      'saleDate': saleDate,
    };
  }

  static CosmeticOrder fromJson(Map<String, dynamic> json) => CosmeticOrder(
        id: json['id'],
        // products: json['products'], //TODO fazer a conversão corretamente
        cicle: json['cicle'],
        // saleDate: json['saleDate'],
      );
}
