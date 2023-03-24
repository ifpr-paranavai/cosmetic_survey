import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CosmeticDialog {
  static Future showAlertDialog(
      {required BuildContext context,
      required String dialogTittle,
      required String dialogDescription,
      required VoidCallback onPressed,
      bool showCancelButton = true}) {
    if (showCancelButton) {
      return showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(dialogTittle),
          content: Text(dialogDescription),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                overlayColor: MaterialStatePropertyAll<Color>(
                  cosmeticPrimaryColor.withOpacity(0.1),
                ),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: cosmeticPrimaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: onPressed,
              style: ButtonStyle(
                overlayColor: MaterialStatePropertyAll<Color>(
                  cosmeticPrimaryColor.withOpacity(0.1),
                ),
              ),
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
    } else {
      return showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(dialogTittle),
          content: Text(dialogDescription),
          actions: <Widget>[
            TextButton(
              onPressed: onPressed,
              style: ButtonStyle(
                overlayColor: MaterialStatePropertyAll<Color>(
                  cosmeticPrimaryColor.withOpacity(0.1),
                ),
              ),
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
}
