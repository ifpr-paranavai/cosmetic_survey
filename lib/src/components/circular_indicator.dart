import 'package:cosmetic_survey/src/constants/colors.dart';
import 'package:flutter/material.dart';

class CosmeticCircularIndicator {
  static showCircularProgressIndicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: cosmeticPrimaryColor,
          ),
        );
      },
    );
  }
}
