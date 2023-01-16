import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/firebase/storage/update_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileActions {
  static Future<XFile?> pickCameraImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();

    return await picker.pickImage(source: ImageSource.camera);
  }

  static Future pickGalleryImage(
      {required BuildContext context, required User user}) async {
    final ImagePicker picker = ImagePicker();
    final ImageCropper cropper = ImageCropper();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // var file = await cropper.cropImage(
      //   sourcePath: image.path,
      //   aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      // );
      StorageDetails.uploadFile(path: image.path, user: user);
    } else {
      Fluttertoast.showToast(
        msg: 'Nenhuma imagem selecionada.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
