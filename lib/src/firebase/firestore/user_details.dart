import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/firebase/firestore/current_user_details.dart';

import '../../constants/firebase_collection.dart';

class UserDetails {
  static Future addUserDetails(
      {required String name, required String email}) async {
    final docUser = FirebaseFirestore.instance
        .collection(FirebaseColletion.USER)
        .doc(CurrentUserDetails.getCurrentUserUid());

    final user = CurrentUser(
      id: docUser.id,
      name: name.trim(),
      email: email.trim(),
      creationTime: DateTime.now().toUtc(),
      imagePath: '',
    ).toJson();

    await docUser.set(user);
  }

  static Future addUserImagePath(
      {required String imagePath, required CurrentUser currentUser}) async {
    final docUser = FirebaseFirestore.instance
        .collection(FirebaseColletion.USER)
        .doc(CurrentUserDetails.getCurrentUserUid());

    await docUser.update({'imagePath': imagePath});
  }
}
