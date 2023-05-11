import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';

class ProductDetails {
  var user = CurrentUserDetails();
  final root = FirebaseFirestore.instance.collection(FirebaseCollection.AUTH);

  Future addProductDetails({required Product product}) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final docProduct = userRef.collection(FirebaseCollection.PRODUCT).doc();

    final doc = Product(
      id: docProduct.id,
      name: product.name.trim(),
      code: product.code,
      price: product.price / 100,
      brandId: product.brandId,
      creationTime: DateTime.now(),
    ).toJson();

    await docProduct.set(doc);
  }

  Future updateProductDetails({required Product product}) async {
    final userRef = root.doc(user.getCurrentUserUid());
    final docCustomer =
        userRef.collection(FirebaseCollection.PRODUCT).doc(product.id);

    final docProduct = Product(
      id: docCustomer.id,
      name: product.name.trim(),
      code: product.code,
      price: product.price / 100,
      brandId: product.brandId,
      creationTime: product.creationTime,
    ).toJson();

    await docCustomer.update(docProduct);
  }

  Stream<List<Product>> readProductDetails() {
    final userRef = root.doc(user.getCurrentUserUid());

    return userRef
        .collection(FirebaseCollection.PRODUCT)
        .orderBy('creationTime', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }

  void deleteProductDetails({required dynamic id}) {
    final userRef = root.doc(user.getCurrentUserUid());

    userRef.collection(FirebaseCollection.PRODUCT).doc(id).delete();
  }

  List<Product> searchAndConvertProducts() {
    List<Product> products = [];

    readProductDetails().forEach(
      (element) {
        for (var product in element) {
          products.add(product);
        }
      },
    );

    return products;
  }
}
