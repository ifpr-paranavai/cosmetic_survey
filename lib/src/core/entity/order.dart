import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';

class CosmeticOrder {
  dynamic id;
  late List<Product> products = <Product>[];
  late Customer customer;
  late double totalValue;
  late int cicle;

  CosmeticOrder({
    this.id,
    required this.products,
    required this.customer,
    required this.totalValue,
    required this.cicle,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products,
      'customer': customer,
      'totalValue': totalValue,
      'cicle': cicle,
    };
  }

  static CosmeticOrder fromJson(Map<String, dynamic> json) => CosmeticOrder(
        id: json['id'],
        products: json['products'], //TODO fazer a conversão corretamente
        customer: json['customer'], //TODO fazer a conversão corretamente
        totalValue: json['totalValue'],
        cicle: json['cicle'],
      );
}
