import 'package:cosmetic_survey/src/core/entity/product.dart';

class Order {
  dynamic id;
  late List<Product> product = <Product>[];
  late double totalValue;
  late String cicle;

  Order({
    this.id,
    required this.product,
    required this.totalValue,
    required this.cicle,
  });
}
