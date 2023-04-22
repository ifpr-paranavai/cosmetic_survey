import 'package:cosmetic_survey/src/core/entity/product.dart';

class CosmeticOrder {
  dynamic id;
  late List<Product>? products = <Product>[];
  late String customerId;
  late int cicle;
  late DateTime? saleDate;
  late String? comments;
  late int? installments;
  late double? totalValue;

  CosmeticOrder({
    this.id,
    this.products,
    required this.customerId,
    required this.cicle,
    this.saleDate,
    this.comments,
    this.installments,
    this.totalValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'products': products.map((product) => product.toJson()),
      'cicle': cicle,
      'saleDate': saleDate,
      'comments': comments,
      'customerId': customerId,
      'installments': installments,
      'totalValue': totalValue,
    };
  }

  static CosmeticOrder fromJson(Map<String, dynamic> json) => CosmeticOrder(
        id: json['id'],
        // products: List<Product>.from(
        //     json['products'].map((product) => Product.fromJson(product))),
        customerId: json['customerId'],
        cicle: json['cicle'],
        saleDate: json['saleDate'].toDate(),
        comments: json['comments'],
        installments: json['installments'],
        totalValue: json['totalValue'],
      );
}
