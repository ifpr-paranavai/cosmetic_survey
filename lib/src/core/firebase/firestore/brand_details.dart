import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/brand.dart';

import '../../constants/firebase_collection.dart';

class BrandDetails {
  Future addBrandDetails({required String name}) async {
    final docBrand =
        FirebaseFirestore.instance.collection(FirebaseColletion.BRAND).doc();

    final brand = Brand(
      id: docBrand.id,
      name: name.trim(),
      creationTime: DateTime.now(),
    ).toJson();

    await docBrand.set(brand);
  }

  Future updateBrandDetails({required Brand cBrand}) async {
    final docBrand = FirebaseFirestore.instance
        .collection(FirebaseColletion.BRAND)
        .doc(cBrand.id);

    final brand = Brand(
      id: docBrand.id,
      name: cBrand.name.trim(),
      creationTime: cBrand.creationTime,
    ).toJson();

    await docBrand.update(brand);
  }

  Stream<List<Brand>> readBrandDetails() => FirebaseFirestore.instance
      .collection(FirebaseColletion.BRAND)
      .orderBy('creationTime', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Brand.fromJson(doc.data())).toList());

  void deleteBrandDetails({required dynamic id}) {
    FirebaseFirestore.instance
        .collection(FirebaseColletion.BRAND)
        .doc(id)
        .delete();
  }

  List<Brand> searchAndConvertBrands() {
    List<Brand> brands = [];

    readBrandDetails().forEach(
      (element) {
        for (var i in element) {
          var brand = Brand(
            id: i.id,
            name: i.name,
            creationTime: i.creationTime,
          );

          brands.add(brand);
        }
      },
    );

    return brands;
  }

  //TODO refatorar para não passar a lista como parâmetro e buscar no firebase pelo id
  dynamic getBrandName(
      {required List<Brand> brands, required dynamic brandId}) {
    for (var i in brands) {
      if (i.id == brandId) {
        return i.name;
      }
    }
  }
}
