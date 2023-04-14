import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';

class OrderDetails {
  Future addOrderDetails(
      {required CosmeticOrder order, required Payment payment}) async {
    final docOrder =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER).doc();

    final doc = CosmeticOrder(
      id: docOrder.id,
      // products: order.products,
      customerId: order.customerId,
      cicle: order.cicle,
      saleDate: DateTime.now(),
      comments: order.comments?.trim(),
      installments: order.installments,
    ).toJson();

    await docOrder.set(doc);

    addPaymentDetails(
      payment: payment,
      installments: order.installments!,
      orderId: docOrder.id,
    );
  }

  Future addPaymentDetails({
    required Payment payment,
    required int installments,
    required dynamic orderId,
  }) async {
    if (installments == 0) {
      for (var i = 0; i <= installments; i++) {
        final docPayment = FirebaseFirestore.instance
            .collection(FirebaseColletion.PAYMENT)
            .doc();

        final doc = Payment(
          id: docPayment.id,
          orderId: orderId,
          installmentValue: payment.installmentValue,
          paymentDate: DateTime.now(),
          installmentNumber: 0,
          paymentType: payment.paymentType,
        ).toJson();

        await docPayment.set(doc);
      }
    } else {
      for (var i = 1; i <= installments; i++) {
        final docPayment = FirebaseFirestore.instance
            .collection(FirebaseColletion.PAYMENT)
            .doc();

        final doc = Payment(
          id: docPayment.id,
          orderId: orderId,
          installmentValue: payment.installmentValue,
          paymentDate: i == 1 ? DateTime.now() : null,
          installmentNumber: i,
          paymentType: i == 1 ? payment.paymentType : '',
        ).toJson();

        await docPayment.set(doc);
      }
    }
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
