import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/brand.dart';

import '../../constants/firebase_collection.dart';

class BrandDetails {
  Future addBrandDetails({required String name}) async {
    final docBrand = FirebaseFirestore.instance.collection(FirebaseColletion.BRAND).doc();

    final brand = Brand(
      id: docBrand.id,
      name: name.trim(),
    ).toJson();

    await docBrand.set(brand);
  }

  Future updateBrandDetails({required dynamic id, required String name}) async {
    final docBrand = FirebaseFirestore.instance.collection(FirebaseColletion.BRAND).doc(id);

    final brand = Brand(
      id: docBrand.id,
      name: name.trim(),
    ).toJson();

    await docBrand.update(brand);
  }

  Stream<List<Brand>> readBrandDetails() => FirebaseFirestore
      .instance.collection(FirebaseColletion.BRAND).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Brand.fromJson(doc.data())).toList());

  void deleteBrandDetails({required dynamic id}) {
    FirebaseFirestore.instance.collection(FirebaseColletion.BRAND).doc(id).delete();
  }

  List<String> readBrandNames() {
    List<String> brands = [];

    readBrandDetails().forEach(
      (element) {
        for (var i in element) {
          brands.add(i.name);
        }
      },
    );

    return brands;
  }

  List<Brand> readBrands() {
    List<Brand> brands = [];

    readBrandDetails().forEach(
      (element) {
        for (var i in element) {
          var brand = Brand(
            id: i.id,
            name: i.name,
          );

          brands.add(brand);
        }
      },
    );

    return brands;
  }

  dynamic getBrandId({required List<Brand> brands, required String brandName}) {
    for (var i in brands) {
      if (i.name == brandName) {
        return i.id;
      }
    }
  }

  dynamic getBrandName(
      {required List<Brand> brands, required dynamic brandId}) {
    for (var i in brands) {
      if (i.id == brandId) {
        return i.name;
      }
    }
  }
}
