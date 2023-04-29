import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';

import '../../constants/firebase_collection.dart';

class CustomerDetails {
  Future addCustomerDetails({required Customer cCustomer}) async {
    final docCustomer =
        FirebaseFirestore.instance.collection(FirebaseColletion.CUSTOMER).doc();

    final customer = Customer(
      id: docCustomer.id,
      name: cCustomer.name.trim(),
      cpf: cCustomer.cpf.trim(),
      cellNumber: cCustomer.cellNumber?.trim(),
      creationTime: DateTime.now(),
    ).toJson();

    await docCustomer.set(customer);
  }

  Future updateCustomerDetails({required Customer cCustomer}) async {
    final docCustomer = FirebaseFirestore.instance
        .collection(FirebaseColletion.CUSTOMER)
        .doc(cCustomer.id);

    final customer = Customer(
      id: docCustomer.id,
      name: cCustomer.name.trim(),
      cpf: cCustomer.cpf.trim(),
      cellNumber: cCustomer.cellNumber?.trim(),
      creationTime: cCustomer.creationTime,
    ).toJson();

    await docCustomer.update(customer);
  }

  Stream<List<Customer>> readCustomerDetails() => FirebaseFirestore.instance
      .collection(FirebaseColletion.CUSTOMER)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Customer.fromJson(doc.data())).toList());

  void deleteCustomerDetails({required dynamic id}) {
    FirebaseFirestore.instance
        .collection(FirebaseColletion.CUSTOMER)
        .doc(id)
        .delete();
  }

  List<Customer> searchAndConvertCustomers() {
    List<Customer> customers = [];

    readCustomerDetails().forEach(
      (element) {
        for (var customer in element) {
          customers.add(customer);
        }
      },
    );

    return customers;
  }

  //TODO refatorar para não passar a lista como parâmetro e buscar no firebase pelo id
  dynamic getCustomerName(
      {required List<Customer> customers, required dynamic customerId}) {
    for (var i in customers) {
      if (i.id == customerId) {
        return i.name;
      }
    }
  }

  Future<Customer> getOrderCustomer(dynamic orderId) async {
    final orderRef = FirebaseFirestore.instance
        .collection(FirebaseColletion.ORDER)
        .doc(orderId);

    var orderSnapshot = await orderRef.get();
    var customerId = orderSnapshot['customerId'];

    final customerRef = FirebaseFirestore.instance
        .collection(FirebaseColletion.CUSTOMER)
        .doc(customerId);

    var customerSnapshot = await customerRef.get();
    return Customer.fromJson(customerSnapshot.data()!);
  }
}
