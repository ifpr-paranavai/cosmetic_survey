import 'package:cosmetic_survey/src/constants/colors.dart';
import 'package:flutter/material.dart';

class CosmeticDialog {
  static Future showAlertDialog(
      {required BuildContext context,
      required String dialogTittle,
      required String dialogDescription,
      required VoidCallback onPressed}) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dialogTittle),
        content: Text(dialogDescription),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: cosmeticPrimaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text(
              'OK',
              style: TextStyle(
                color: cosmeticPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
