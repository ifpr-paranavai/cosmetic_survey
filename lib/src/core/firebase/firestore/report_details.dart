import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/constants/order_status.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/utils/pair.dart';
import 'package:decimal/decimal.dart';

class ReportDetails {
  var user = CurrentUserDetails();
  final root = FirebaseFirestore.instance.collection(FirebaseCollection.AUTH);
  var utils = Utils();
  var orderDetails = OrderDetails();

  Future<Pair> buildReport({
    required DateTime startDate,
    required DateTime endDate,
    int? cicle,
    String? orderStatus,
  }) async {
    final userRef = root.doc(user.getCurrentUserUid());
    Query query = userRef.collection(FirebaseCollection.ORDER);
    var orders = <CosmeticOrder>[];
    var inProgressOrders = <CosmeticOrder>[];
    var paidOrders = <CosmeticOrder>[];
    var pair = Pair(value: Decimal.zero, orders: []);

    query = query.where('saleDate',
        isGreaterThanOrEqualTo: utils.getBeginningOfTheDay(startDate));

    query = query.where('saleDate',
        isLessThanOrEqualTo: utils.getEndOfTheDay(endDate));

    if (cicle != null) {
      query = query.where('cicle', isEqualTo: cicle);
    }

    query = query.orderBy('saleDate', descending: true);

    final querySnapshot = await query.get();

    for (var doc in querySnapshot.docs) {
      var order = CosmeticOrder.fromJson(doc.data() as Map<String, dynamic>);

      orders.add(order);
    }

    if (orderStatus != null && orderStatus.isNotEmpty) {
      for (var order in orders) {
        if (orderStatus == OrderStatus.EM_ANDAMENTO &&
            order.missingValue != 0) {
          inProgressOrders.add(order);
        } else if (orderStatus == OrderStatus.PAGO && order.missingValue == 0) {
          paidOrders.add(order);
        }
      }

      if (orderStatus == OrderStatus.EM_ANDAMENTO) {
        pair.value = getOrderTotalValue(inProgressOrders);
        pair.orders = inProgressOrders;
      } else if (orderStatus == OrderStatus.PAGO) {
        pair.value = getOrderTotalValue(paidOrders);
        pair.orders = paidOrders;
      } else {
        pair.value = getOrderTotalValue(orders);
        pair.orders = orders;
      }
    } else {
      pair.value = getOrderTotalValue(orders);
      pair.orders = orders;
    }

    return pair;
  }

  Decimal getOrderTotalValue(List<CosmeticOrder> orders) {
    var totalValue = Decimal.zero;

    for (var order in orders) {
      totalValue += Decimal.parse(order.totalValue!.toString());
    }

    return totalValue;
  }
}
