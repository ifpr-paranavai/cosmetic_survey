import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/order_products.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';

class OrderDetails {
  Future addOrderDetails(
      {required CosmeticOrder order, required Payment payment}) async {
    final docOrder =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER).doc();

    final doc = CosmeticOrder(
      id: docOrder.id,
      customerId: order.customerId,
      cicle: order.cicle,
      saleDate: DateTime.now(),
      comments: order.comments?.trim(),
      installments: order.installments,
      totalValue: order.totalValue,
    ).toJson();

    await docOrder.set(doc);

    addOrderProductsDetails(order: order, docOrder: docOrder);

    addPaymentDetails(
      payment: payment,
      installments: order.installments!,
      docOrder: docOrder,
      totalValue: order.totalValue!,
    );
  }

  Future addOrderProductsDetails(
      {required CosmeticOrder order,
      required DocumentReference docOrder}) async {
    for (var product in order.products!) {
      final docOrderProducts =
          docOrder.collection(FirebaseColletion.ORDER_PRODUCTS).doc();

      final doc = OrderProducts(
        id: docOrderProducts.id,
        quantity: product.quantity!,
        price: product.price,
        orderId: docOrder.id,
        productId: product.id,
      ).toJson();

      await docOrderProducts.set(doc);
    }
  }

  Future addPaymentDetails({
    required Payment payment,
    required int installments,
    required DocumentReference docOrder,
    required double totalValue,
  }) async {
    if (installments == 0) {
      for (var i = 0; i <= installments; i++) {
        final docPayment = docOrder.collection(FirebaseColletion.PAYMENT).doc();

        final doc = Payment(
          id: docPayment.id,
          orderId: docOrder.id,
          installmentValue: totalValue,
          paymentDate: DateTime.now(),
          installmentNumber: 0,
          paymentType: payment.paymentType,
        ).toJson();

        await docPayment.set(doc);
      }
    } else {
      for (var i = 1; i <= installments; i++) {
        final docPayment = docOrder.collection(FirebaseColletion.PAYMENT).doc();

        final doc = Payment(
          id: docPayment.id,
          orderId: docOrder.id,
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
