import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/brand.dart';

import '../../constants/firebase_collection.dart';

class BrandDetails {
  static Future addBrandDetails({required String name}) async {
    final docBrand = FirebaseFirestore.instance.collection(FirebaseColletion.BRAND).doc();

    final brand = Brand(
      id: docBrand.id,
      name: name.trim(),
    ).toJson();

    await docBrand.set(brand);
  }

  static Future updateBrandDetails({required dynamic id, required String name}) async {
    final docBrand = FirebaseFirestore.instance.collection(FirebaseColletion.BRAND).doc(id);

    final brand = Brand(
      id: docBrand.id,
      name: name.trim(),
    ).toJson();

    await docBrand.update(brand);
  }

  static Stream<List<Brand>> readBrandDetails() => FirebaseFirestore
      .instance.collection(FirebaseColletion.BRAND).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Brand.fromJson(doc.data())).toList());

  static void deleteBrandDetails({required dynamic id}) {
    FirebaseFirestore.instance.collection(FirebaseColletion.BRAND).doc(id).delete();
  }
}
