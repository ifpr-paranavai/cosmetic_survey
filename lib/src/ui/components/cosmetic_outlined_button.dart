import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class CosmeticOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  String buttonName;

  CosmeticOutlinedButton(
      {Key? key, required this.buttonName, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: cosmeticSecondaryColor,
        side: const BorderSide(
          color: cosmeticSecondaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: cosmeticButtonHeight,
        ),
      ),
      child: Text(
        buttonName,
      ),
    );
  }
}
