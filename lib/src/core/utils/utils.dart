import 'package:permission_handler/permission_handler.dart';

import '../../constants/firebase_providers.dart';
import '../../firebase/firestore/current_user_details.dart';

class PermissionHandler {
  Future askForPermissionCamera() async {
    return await Permission.camera.request();
  }

  Future askForPermissionPhotos() async {
    return await Permission.photos.request();
  }

  bool isFirebaseUser() {
    if (CurrentUserDetails.getCurrentUserProvider() ==
        FirebaseProvider.GOOGLE) {
      return true;
    }
    return false;
  }
}
