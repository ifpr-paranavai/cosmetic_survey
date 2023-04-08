class CosmeticOrder {
  dynamic id;

  // late List<Product> products = <Product>[];
  late String customerId;
  late int cicle;
  late DateTime? saleDate;
  late String? comments;
  late int? installments;
  late double? totalValue;

  CosmeticOrder({
    this.id,
    // required this.products,
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
      // 'products': products,
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
        // products: json['products'], //TODO fazer a conversão corretamente
        customerId: json['customerId'],
        cicle: json['cicle'],
        saleDate: json['saleDate'].toDate(),
        comments: json['comments'],
        installments: json['installments'],
        totalValue: json['totalValue'],
      );
}
