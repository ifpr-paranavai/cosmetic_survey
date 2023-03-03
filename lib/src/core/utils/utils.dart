import 'package:cosmetic_survey/src/core/constants/firebase_providers.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future<bool> askPermissionCamera() async {
    var permission = await Permission.camera.request();

    if (permission.isGranted) {
      return true;
    }
    return false;
  }

  static Future<bool> isPermissionCameraDenied() async {
    if (await Permission.camera.isDenied) {
      return true;
    }
    return false;
  }

  static Future<bool> askPermissionStorage() async {
    var permission = await Permission.storage.request();

    if (permission.isGranted) {
      return true;
    }
    return false;
  }

  static Future<bool> isPermissionCameraStorage() async {
    if (await Permission.storage.isDenied) {
      return true;
    }
    return false;
  }

  static bool isFirebaseUser() {
    CurrentUserDetails currentUserDetails = CurrentUserDetails();
    
    if (currentUserDetails.getCurrentUserProvider() ==
        FirebaseProvider.GOOGLE) {
      return true;
    }
    return false;
  }
}
