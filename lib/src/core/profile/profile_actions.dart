import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/firebase/storage/update_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfileActions {
  static Future pickCameraImage(
      {required BuildContext context, required CurrentUser user}) async {
    final ImagePicker picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      StorageDetails.uploadFile(path: image.path, user: user).then(
        (value) => {
          Navigator.pop(context),
          Fluttertoast.showToast(
            msg: 'Imagem de perfil atualizada!',
            gravity: ToastGravity.BOTTOM,
          ),
        },
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Nenhuma imagem tirada.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  static Future pickGalleryImage(
      {required BuildContext context, required CurrentUser user}) async {
    final ImagePicker picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      StorageDetails.uploadFile(path: image.path, user: user).then(
        (value) => {
          Navigator.pop(context),
          Fluttertoast.showToast(
            msg: 'Imagem de perfil atualizada!',
            gravity: ToastGravity.BOTTOM,
          ),
        },
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Nenhuma imagem selecionada.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
