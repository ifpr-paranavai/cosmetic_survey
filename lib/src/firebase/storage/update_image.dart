import 'package:cosmetic_survey/src/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/firebase/firestore/current_user_details.dart';
import 'package:cosmetic_survey/src/firebase/firestore/user_details.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageDetails {
  static Future uploadFile({required String path, required User user}) async {
    final userPath = 'user_${CurrentUserDetails.getCurrentUserUid()}_profile';

    FirebaseStorage.instance
        .ref()
        .child(FirebaseColletion.PROFILE_IMAGE)
        .child(userPath);

    FirebaseUserDetails.addUserImagePath(imagePath: path, currentUser: user);

    return path;
  }
}
