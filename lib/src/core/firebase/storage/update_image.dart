import 'dart:io';

import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/user_details.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../constants/image_path.dart';

class StorageDetails {
  Future uploadFile({required String path, required CurrentUser user}) async {
    CurrentUserDetails currentUserDetails = CurrentUserDetails();
    UserDetails userDetails = UserDetails();
    
    final fileName = 'user_${currentUserDetails.getCurrentUserUid()}_profile';
    final finalUrl = cosmeticFirestoreUrl + fileName + cosmeticFirestoreUrlEnd;

    final ref = FirebaseStorage.instance
        .ref()
        .child(FirebaseCollection.PROFILE_IMAGE)
        .child(fileName);

    final result = await ref.putFile(File(path));

    userDetails.addUserImagePath(imagePath: finalUrl, currentUser: user);

    return result;
  }
}
