import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';

class CosmeticElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  String buttonName;

  CosmeticElevatedButton(
      {Key? key, required this.buttonName, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: cosmeticWhiteColor,
        backgroundColor: cosmeticSecondaryColor,
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
