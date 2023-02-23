import 'package:cosmetic_survey/src/core/entity/product.dart';

class CosmeticOrder {
  dynamic id;
  late List<Product> products = <Product>[];
  late double totalValue;
  late int cicle;

  CosmeticOrder({
    this.id,
    required this.products,
    required this.totalValue,
    required this.cicle,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products,
      'totalValue': totalValue,
      'cicle': cicle,
    };
  }

  static CosmeticOrder fromJson(Map<String, dynamic> json) => CosmeticOrder(
        id: json['id'],
        products: json['products'], //TODO fazer a conversão corretamente
        totalValue: json['totalValue'],
        cicle: json['cicle'],
      );
}
