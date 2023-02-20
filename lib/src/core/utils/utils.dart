import 'package:permission_handler/permission_handler.dart';

import '../../constants/firebase_providers.dart';
import '../../firebase/firestore/current_user_details.dart';

class Utils {
  static Future<bool> askPermissionCamera() async {
    var permission = await Permission.camera.request();

    if (permission.isGranted) {
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

  static bool isFirebaseUser() {
    if (CurrentUserDetails.getCurrentUserProvider() ==
        FirebaseProvider.GOOGLE) {
      return true;
    }
    return false;
  }
}
