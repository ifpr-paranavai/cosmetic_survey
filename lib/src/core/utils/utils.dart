import 'package:permission_handler/permission_handler.dart';

import '../../constants/firebase_providers.dart';
import '../../firebase/firestore/current_user_details.dart';

class Utils {
  static Future askPermissionCamera() async {
    return await Permission.camera.request();
  }

  static Future askPermissionPhotos() async {
    return await Permission.photos.request();
  }

  static bool isFirebaseUser() {
    if (CurrentUserDetails.getCurrentUserProvider() ==
        FirebaseProvider.GOOGLE) {
      return true;
    }
    return false;
  }
}
