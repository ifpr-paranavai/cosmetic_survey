import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';

import '../../constants/firebase_collection.dart';

class FirebaseUserDetails {
  List<String> documentsId = [];

  static Future addUserDetails({required String name, required String email}) async {
    final docUser = FirebaseFirestore.instance.collection(FirebaseColletion.USER).doc();

    final user = User(
      id: docUser.id,
      name: name.trim(),
      email: email.trim(),
    ).toJson();

    await docUser.set(user);
  }

  static Future<User?> readUserDetails({required dynamic id}) async {
    final docUser = FirebaseFirestore.instance.collection(FirebaseColletion.USER).doc(id);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return User.fromJson(snapshot.data()!);
    }
    return null;
  }

  // static Future<User?> getCurrentUserDetails({dynamic id}) async {
  //   await FirebaseFirestore.instance
  //       .collection(FirebaseColletion.USER).get().then(
  //         (snapshot) => snapshot.docs.forEach(
  //           (document) {
  //             if (id == document.reference.id) {
  //               return;
  //             }
  //           },
  //         ),
  //       );
  //   return null;
  // }
}
