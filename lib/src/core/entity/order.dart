class CosmeticOrder {
  dynamic id;

  // late List<Product> products = <Product>[];
  late String customerId;
  late int cicle;
  late DateTime? saleDate;
  late String? comments;
  late int? installments;

  CosmeticOrder({
    this.id,
    // required this.products,
    required this.customerId,
    required this.cicle,
    this.saleDate,
    this.comments,
    this.installments
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
    };
  }

  static CosmeticOrder fromJson(Map<String, dynamic> json) => CosmeticOrder(
        id: json['id'],
        // products: json['products'], //TODO fazer a conversão corretamente
        customerId: json['customerId'],
        cicle: json['cicle'],
        comments: json['comments'],
        installments: json['installments'],
      );
}
