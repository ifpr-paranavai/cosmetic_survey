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

  Future buildReport(
    DateTime initialDate,
    DateTime finalDate,
    int cicle,
    String orderStatus,
  ) async {
    final userRef = root.doc(user.getCurrentUserUid());

    var query = userRef
        .collection(FirebaseCollection.ORDER)
        .where("saleDate", isGreaterThanOrEqualTo: initialDate)
        .where("saleDate", isLessThanOrEqualTo: finalDate)
        .where("cicle", isEqualTo: cicle);

    if (orderStatus == OrderStatus.EM_ANDAMENTO) {
      query = query.where("missingValue", isGreaterThan: 0);
    } else {
      query = query.where("missingValue", isEqualTo: 0);
    }

    query = query.orderBy('saleDate', descending: true);

    return query.get().then((snapshot) => snapshot.docs
        .map((doc) => CosmeticOrder.fromJson(doc.data()))
        .toList());
  }
}
