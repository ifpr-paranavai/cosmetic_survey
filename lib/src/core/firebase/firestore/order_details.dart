import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/order_products.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';

class OrderDetails {
  var user = CurrentUserDetails();
  final root = FirebaseFirestore.instance.collection(FirebaseCollection.AUTH);
  var utils = Utils();

  Future addOrderDetails({
    required CosmeticOrder order,
    required Payment payment,
  }) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final docOrder = userRef.collection(FirebaseCollection.ORDER).doc();

    final doc = CosmeticOrder(
      id: docOrder.id,
      customerId: order.customerId,
      cicle: order.cicle,
      saleDate: DateTime.now(),
      comments: order.comments?.trim(),
      installments: order.installments,
      totalValue: order.totalValue,
      missingValue: order.missingValue,
    ).toJson();

    await docOrder.set(doc);

    addOrderProductsDetails(order: order, docOrder: docOrder);

    addPaymentDetails(
      payment: payment,
      order: order,
      docOrder: docOrder,
    );
  }

  Future addOrderProductsDetails({
    required CosmeticOrder order,
    required DocumentReference docOrder,
  }) async {
    for (var product in order.products!) {
      final docOrderProducts =
          docOrder.collection(FirebaseCollection.ORDER_PRODUCTS).doc();

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
    required CosmeticOrder order,
    required DocumentReference docOrder,
  }) async {
    if (order.installments == 0) {
      for (var i = 0; i <= order.installments!; i++) {
        final docPayment =
            docOrder.collection(FirebaseCollection.PAYMENT).doc();

        final doc = Payment(
          id: docPayment.id,
          orderId: docOrder.id,
          installmentValue: order.totalValue,
          paymentDate: DateTime.now(),
          installmentNumber: 0,
          paymentType: payment.paymentType,
        ).toJson();

        await docPayment.set(doc);
      }
    } else {
      for (var i = 1; i <= order.installments!; i++) {
        final docPayment =
            docOrder.collection(FirebaseCollection.PAYMENT).doc();

        final doc = Payment(
          id: docPayment.id,
          orderId: docOrder.id,
          installmentValue: i == 1
              ? payment.installmentValue
              : order.missingValue! / (order.installments! - 1),
          paymentDate: i == 1 ? DateTime.now() : null,
          installmentNumber: i,
          paymentType: i == 1 ? payment.paymentType : '',
        ).toJson();

        await docPayment.set(doc);
      }
    }
  }

  Stream<List<CosmeticOrder>> readOrderDetails() {
    final userRef = root.doc(user.getCurrentUserUid());

    return userRef
        .collection(FirebaseCollection.ORDER)
        .orderBy('saleDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CosmeticOrder.fromJson(doc.data()))
            .toList());
  }

  Future updateOrderDetails(CosmeticOrder order) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderDoc = userRef.collection(FirebaseCollection.ORDER).doc(order.id);

    await orderDoc.update({'comments': order.comments});
  }

  void deleteOrderDetails({required dynamic id}) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);
    final orderProductsRef =
        orderRef.doc(id).collection(FirebaseCollection.ORDER_PRODUCTS);
    final paymentRef = orderRef.doc(id).collection(FirebaseCollection.PAYMENT);

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
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);

    final docs = await orderRef.get();
    return docs.size;
  }

  Future<double> getOrdersTotalValue() async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);

    var ordersTotalValue = 0.0;

    final orders = await orderRef.get();

    for (var order in orders.docs) {
      var currentOrder = CosmeticOrder.fromJson(order.data());

      ordersTotalValue += currentOrder.totalValue!;
    }

    return ordersTotalValue;
  }

  Future<List<Payment>> readAllPaymentDetails() async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);

    var payments = <Payment>[];

    // recupero todos os pedidos
    var ordersCollection = await orderRef.get();

    for (var orderDoc in ordersCollection.docs) {
      final paymentRef =
          orderDoc.reference.collection(FirebaseCollection.PAYMENT);

      // recupero os pagamentos do pedido
      var paymentsCollection = await paymentRef.get();

      for (var paymentDoc in paymentsCollection.docs) {
        payments.add(Payment.fromJson(paymentDoc.data()));
      }
    }
    return payments;
  }

  Future<List<Payment>> readPaymentDetailsByOrderId(dynamic id) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);
    final paymentRef = orderRef.doc(id).collection(FirebaseCollection.PAYMENT);

    var payments = <Payment>[];

    var paymentSnapshots = await paymentRef.orderBy('installmentNumber').get();

    for (var payment in paymentSnapshots.docs) {
      payments.add(Payment.fromJson(payment.data()));
    }

    return payments;
  }

  Future updatePaymentDetails(Payment payment) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);
    final paymentRef =
        orderRef.doc(payment.orderId).collection(FirebaseCollection.PAYMENT);

    final doc = Payment(
      id: payment.id,
      orderId: payment.orderId,
      installmentValue: payment.installmentValue,
      paymentDate: payment.paymentDate,
      installmentNumber: payment.installmentNumber,
      paymentType: payment.paymentType,
    ).toJson();

    updateMissingValue(payment);

    await paymentRef.doc(payment.id).update(doc);
  }

  Future updateMissingValue(Payment payment) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);

    var orderCollection = await orderRef.doc(payment.orderId).get();

    var order = CosmeticOrder.fromJson(orderCollection.data()!);

    await orderRef.doc(payment.orderId).update({
      "missingValue": utils.fixDecimalValue(order.missingValue!) -
          payment.installmentValue!,
    });

    updateInstallmentValue(payment);
  }

  Future updateInstallmentValue(Payment payment) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);
    final paymentRef =
        orderRef.doc(payment.orderId).collection(FirebaseCollection.PAYMENT);

    var paymentsToPay = <Payment>[];
    var paymentSnapshots = await paymentRef.get();

    var orderSnapshot = await orderRef.doc(payment.orderId).get();
    var order = CosmeticOrder.fromJson(orderSnapshot.data()!);

    for (var payment in paymentSnapshots.docs) {
      var paymnt = Payment.fromJson(payment.data());

      if (paymnt.paymentDate == null) {
        paymentsToPay.add(paymnt);
      }
    }

    for (var it in paymentsToPay) {
      await paymentRef.doc(it.id).update({
        "installmentValue":
            utils.fixDecimalValue(order.missingValue!) / paymentsToPay.length,
      });
    }
  }

  Future<CosmeticOrder> readOrderDetailsById(dynamic id) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER).doc(id);

    var order = await orderRef.get();

    return CosmeticOrder.fromJson(order.data()!);
  }

  Future<int> getOrderProductQuantity(dynamic id) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);
    final orderProductsRef =
        orderRef.doc(id).collection(FirebaseCollection.ORDER_PRODUCTS);

    var orderProductsSnapshots = await orderProductsRef.get();

    return orderProductsSnapshots.size;
  }

  Future<List<Product>> getOrderProducts(dynamic orderId) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final orderRef = userRef.collection(FirebaseCollection.ORDER);
    final orderProductsRef =
        orderRef.doc(orderId).collection(FirebaseCollection.ORDER_PRODUCTS);

    var products = <Product>[];

    var orderProductsSnapshots = await orderProductsRef.get();
    for (var doc in orderProductsSnapshots.docs) {
      var productId = doc['productId'];
      var quantitySold = doc['quantity'];
      var price = doc['price'];

      final productRef =
          userRef.collection(FirebaseCollection.PRODUCT).doc(productId);

      var productSnapshot = await productRef.get();
      var product = Product.fromJson(productSnapshot.data()!);
      product.quantity = quantitySold;
      product.price = price;

      products.add(product);
    }

    return products;
  }
}
