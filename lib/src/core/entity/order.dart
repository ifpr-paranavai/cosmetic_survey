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
  late double? missingValue;

  CosmeticOrder({
    this.id,
    this.products,
    required this.customerId,
    required this.cicle,
    this.saleDate,
    this.comments,
    this.installments,
    this.totalValue,
    this.missingValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cicle': cicle,
      'saleDate': saleDate,
      'comments': comments,
      'customerId': customerId,
      'installments': installments,
      'totalValue': totalValue,
      'missingValue': missingValue,
    };
  }

  static CosmeticOrder fromJson(Map<String, dynamic> json) => CosmeticOrder(
        id: json['id'],
        customerId: json['customerId'],
        cicle: json['cicle'],
        saleDate: json['saleDate'].toDate(),
        comments: json['comments'],
        installments: json['installments'],
        totalValue: json['totalValue'],
        missingValue: json['missingValue'],
      );
}
