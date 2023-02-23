import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';

class OrderDetails {
  static Future addOrderDetails({required CosmeticOrder order}) async {
    final docOrder =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER).doc();

    final doc = CosmeticOrder(
      id: docOrder.id,
      products: order.products,
      totalValue: order.totalValue,
      cicle: order.cicle,
    ).toJson();

    await docOrder.set(doc);
  }

  static Future updateOrderDetails({required CosmeticOrder order}) async {
    final docOrder = FirebaseFirestore.instance
        .collection(FirebaseColletion.ORDER)
        .doc(order.id);

    final doc = CosmeticOrder(
      id: docOrder.id,
      products: order.products,
      totalValue: order.totalValue,
      cicle: order.cicle,
    ).toJson();

    await docOrder.update(doc);
  }

  static Stream<List<CosmeticOrder>> readOrderDetails() =>
      FirebaseFirestore.instance
          .collection(FirebaseColletion.ORDER)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CosmeticOrder.fromJson(doc.data()))
              .toList());

  static void deleteOrderDetails({required dynamic id}) {
    FirebaseFirestore.instance
        .collection(FirebaseColletion.ORDER)
        .doc(id)
        .delete();
  }
}
