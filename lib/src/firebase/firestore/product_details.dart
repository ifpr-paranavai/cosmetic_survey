import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';

class FirebaseProductDetails {
  static Future addProductDetails({required Product product}) async {
    final docCustomer =
        FirebaseFirestore.instance.collection(FirebaseColletion.PRODUCT).doc();

    final docProduct = Product(
      id: docCustomer.id,
      name: product.name.trim(),
      code: product.code.trim(),
      value: product.value / 100,
    ).toJson();

    await docCustomer.set(docProduct);
  }

  static Future updateProductDetails({required Product product}) async {
    final docCustomer = FirebaseFirestore.instance
        .collection(FirebaseColletion.PRODUCT)
        .doc(product.id);

    final docProduct = Product(
      id: docCustomer.id,
      name: product.name.trim(),
      code: product.code.trim(),
      value: product.value / 100,
    ).toJson();

    await docCustomer.update(docProduct);
  }

  static Stream<List<Product>> readProductDetails() => FirebaseFirestore
      .instance
      .collection(FirebaseColletion.PRODUCT)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  static void deleteProductDetails({required dynamic id}) {
    FirebaseFirestore.instance
        .collection(FirebaseColletion.PRODUCT)
        .doc(id)
        .delete();
  }
}
