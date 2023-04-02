class CosmeticOrder {
  dynamic id;

  // late List<Product> products = <Product>[];
  late String customerId;
  late int cicle;
  late DateTime? saleDate;
  late String? comments;

  CosmeticOrder({
    this.id,
    // required this.products,
    required this.customerId,
    required this.cicle,
    this.saleDate,
    this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'products': products,
      'cicle': cicle,
      'saleDate': saleDate,
      'comments': comments,
      'customerId': customerId,
    };
  }

  static CosmeticOrder fromJson(Map<String, dynamic> json) => CosmeticOrder(
        id: json['id'],
        // products: json['products'], //TODO fazer a conversão corretamente
        customerId: json['customerId'],
        cicle: json['cicle'],
        comments: json['comments'],
      );
}
