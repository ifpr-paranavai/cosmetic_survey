import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';

import '../../constants/firebase_collection.dart';

class FirebaseCustomerDetails {
  static Future addCustomerDetails({required String name, required String cpfCnpj}) async {
    final docCustomer = FirebaseFirestore.instance.collection(FirebaseColletion.CUSTOMER).doc();

    final customer = Customer(
      id: docCustomer.id,
      name: name.trim(),
      cpfCnpj: cpfCnpj.trim(),
    ).toJson();

    await docCustomer.set(customer);
  }

  static Stream<List<Customer>> readCustomerDetails() => FirebaseFirestore
      .instance.collection(FirebaseColletion.CUSTOMER).snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Customer.fromJson(doc.data())).toList());

  static void deleteCustomerDetails({required dynamic id}) {
    FirebaseFirestore.instance.collection(FirebaseColletion.CUSTOMER).doc(id).delete();
  }
}
