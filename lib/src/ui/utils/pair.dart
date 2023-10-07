import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:decimal/decimal.dart';

class Pair {
  late Decimal value;
  late List<CosmeticOrder> orders;

  Pair({required this.value, required this.orders});
}
