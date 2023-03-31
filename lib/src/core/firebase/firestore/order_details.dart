import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';

class OrderDetails {
  Future addOrderDetails({required CosmeticOrder order}) async {
    final docOrder =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER).doc();

    final doc = CosmeticOrder(
      id: docOrder.id,
      // products: order.products,
      cicle: order.cicle,
      saleDate: DateTime.now(),
      comments: order.comments?.trim(),
    ).toJson();

    await docOrder.set(doc);
  }

  Stream<List<CosmeticOrder>> readOrderDetails() => FirebaseFirestore.instance
      .collection(FirebaseColletion.ORDER)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CosmeticOrder.fromJson(doc.data()))
          .toList());

  void deleteOrderDetails({required dynamic id}) {
    FirebaseFirestore.instance
        .collection(FirebaseColletion.ORDER)
        .doc(id)
        .delete();
  }
}
