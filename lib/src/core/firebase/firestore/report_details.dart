import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/constants/order_status.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';

class ReportDetails {
  var user = CurrentUserDetails();
  final root = FirebaseFirestore.instance.collection(FirebaseCollection.AUTH);
  var utils = Utils();

  Future<List<CosmeticOrder>> buildReport({
    required DateTime startDate,
    required DateTime endDate,
    int? cicle,
    String? orderStatus,
  }) async {
    final userRef = root.doc(user.getCurrentUserUid());
    Query query = userRef.collection(FirebaseCollection.ORDER);
    var orders = <CosmeticOrder>[];

    query = query.where('saleDate',
        isGreaterThanOrEqualTo: utils.getBeginningOfTheDay(startDate));

    query = query.where('saleDate',
        isLessThanOrEqualTo: utils.getEndOfTheDay(endDate));

    if (cicle != null) {
      query = query.where('cicle', isEqualTo: cicle);
    }

    if (orderStatus != null) {
      if (orderStatus == OrderStatus.EM_ANDAMENTO) {
        query = query.where('missingValue', isNotEqualTo: 0); //todo corrigir este filtro
      } else if (orderStatus == OrderStatus.PAGO) {
        query = query.where('missingValue', isEqualTo: 0);
      }
    }

    query = query.orderBy('saleDate', descending: true);

    final querySnapshot = await query.get();

    for (var doc in querySnapshot.docs) {
      var order = CosmeticOrder.fromJson(doc.data() as Map<String, dynamic>);

      orders.add(order);
    }

    return orders;
  }
}
