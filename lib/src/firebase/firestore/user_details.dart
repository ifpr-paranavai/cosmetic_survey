import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/firebase/firestore/current_user_details.dart';

import '../../constants/firebase_collection.dart';

class FirebaseUserDetails {
  static Future addUserDetails(
      {required String name, required String email}) async {
    final docUser = FirebaseFirestore.instance
        .collection(FirebaseColletion.USER)
        .doc(CurrentUserDetails.getCurrentUserUid());

    final user = User(
      id: docUser.id,
      name: name.trim(),
      email: email.trim(),
      creationTime: DateTime.now().toUtc(),
      imagePath: '',
    ).toJson();

    await docUser.set(user);
  }

  static Future addUserImagePath(
      {required String imagePath, required User currentUser}) async {
    final docUser = FirebaseFirestore.instance
        .collection(FirebaseColletion.USER)
        .doc(CurrentUserDetails.getCurrentUserUid());

    final user = User(
      id: docUser.id,
      name: currentUser.name.trim(),
      email: currentUser.email.trim(),
      imagePath: imagePath.trim(),
    ).toJson();

    await docUser.update(user);
  }
}
