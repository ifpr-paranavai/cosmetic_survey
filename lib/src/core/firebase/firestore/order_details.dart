import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/order_products.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';

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

  void deleteOrderDetails({required dynamic id}) async {
    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER);
    final orderProductsRef =
        orderRef.doc(id).collection(FirebaseColletion.ORDER_PRODUCTS);
    final paymentRef = orderRef.doc(id).collection(FirebaseColletion.PAYMENT);

    var orderProductsSnapshots = await orderProductsRef.get();
    orderProductsSnapshots.docs.forEach((doc) async {
      await doc.reference.delete();
    });

    var paymentSnapshots = await paymentRef.get();
    paymentSnapshots.docs.forEach((doc) async {
      await doc.reference.delete();
    });

    await orderRef.doc(id).delete();
  }

  Future<int> getOrderQuantity() async {
    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER);

    final docs = await orderRef.get();
    return docs.size;
  }

  Future<double> getOrdersTotalValue() async {
    var ordersTotalValue = 0.0;

    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER);

    final orders = await orderRef.get();

    for (var order in orders.docs) {
      var currentOrder = CosmeticOrder.fromJson(order.data());

      ordersTotalValue += currentOrder.totalValue!;
    }

    return ordersTotalValue;
  }

  Future<List<Payment>> readAllPaymentDetails() async {
    var payments = <Payment>[];

    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER);

    // recupero todos os pedidos
    var ordersCollection = await orderRef.get();

    for (var orderDoc in ordersCollection.docs) {
      final paymentRef =
          orderDoc.reference.collection(FirebaseColletion.PAYMENT);

      // recupero os pagamentos do pedido
      var paymentsCollection = await paymentRef.get();

      for (var paymentDoc in paymentsCollection.docs) {
        payments.add(Payment.fromJson(paymentDoc.data()));
      }
    }
    return payments;
  }

  Future<List<Payment>> readPaymentDetailsByOrderId(dynamic id) async {
    var payments = <Payment>[];

    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER);
    final paymentRef = orderRef.doc(id).collection(FirebaseColletion.PAYMENT);

    var paymentSnapshots = await paymentRef.orderBy('installmentNumber').get();

    for (var payment in paymentSnapshots.docs) {
      payments.add(Payment.fromJson(payment.data()));
    }

    return payments;
  }

  Future updatePaymentDetails(Payment payment) async {
    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER);
    final paymentRef =
        orderRef.doc(payment.orderId).collection(FirebaseColletion.PAYMENT);

    final doc = Payment(
      id: payment.id,
      orderId: payment.orderId,
      installmentValue: payment.installmentValue,
      paymentDate: DateTime.now(),
      installmentNumber: payment.installmentNumber,
      paymentType: payment.paymentType,
    ).toJson();

    await paymentRef.doc(payment.id).update(doc);
  }

  Future<CosmeticOrder> readOrderDetailsById(dynamic id) async {
    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER).doc(id);

    var order = await orderRef.get();

    return CosmeticOrder.fromJson(order.data()!);
  }

  Future<int> getOrderProductQuantity(dynamic id) async {
    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER);
    final orderProductsRef =
        orderRef.doc(id).collection(FirebaseColletion.ORDER_PRODUCTS);

    var orderProductsSnapshots = await orderProductsRef.get();

    return orderProductsSnapshots.size;
  }

  Future<List<Product>> getOrderProducts(dynamic orderId) async {
    var products = <Product>[];

    final orderRef =
        FirebaseFirestore.instance.collection(FirebaseColletion.ORDER);
    final orderProductsRef =
        orderRef.doc(orderId).collection(FirebaseColletion.ORDER_PRODUCTS);

    var orderProductsSnapshots = await orderProductsRef.get();
    for (var doc in orderProductsSnapshots.docs) {
      var productId = doc['productId'];
      var quantitySold = doc['quantity'];
      var price = doc['price'];

      final productRef = FirebaseFirestore.instance
          .collection(FirebaseColletion.PRODUCT)
          .doc(productId);

      var productSnapshot = await productRef.get();
      var product = Product.fromJson(productSnapshot.data()!);
      product.quantity = quantitySold;
      product.price = price;

      products.add(product);
    }

    return products;
  }
}
