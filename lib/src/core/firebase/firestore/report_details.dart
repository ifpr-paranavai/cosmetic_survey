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
    DateTime? startDate,
    DateTime? endDate,
    int? cicle,
    String? orderStatus,
  }) async {
    final userRef = root.doc(user.getCurrentUserUid());
    var orderRef = userRef.collection(FirebaseCollection.ORDER);
    var orders = <CosmeticOrder>[];

    Query query = orderRef
        .where('cicle', isEqualTo: cicle)
        .orderBy('saleDate', descending: true);

    if (startDate != null) {
      query = query.where('saleDate', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('saleDate', isLessThanOrEqualTo: endDate);
    }

    if (orderStatus == OrderStatus.EM_ANDAMENTO) {
      query = query.where('missingValue', isGreaterThan: 0);
    } else if (orderStatus == OrderStatus.PAGO) {
      query = query.where('missingValue', isEqualTo: 0);
    }

    final querySnapshot = await query.get();

    orders = querySnapshot.docs
        .map(
            (doc) => CosmeticOrder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return orders;
  }
}
