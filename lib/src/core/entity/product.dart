class Product {
  dynamic id;
  late String name;
  late double value;
  late double quantity;
  late String code;

  Product({
    this.id,
    required this.name,
    required this.value,
    required this.quantity,
    required this.code,
  });
}
