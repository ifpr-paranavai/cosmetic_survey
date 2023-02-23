import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CosmeticFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  CosmeticFloatingActionButton(
      {Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: cosmeticPrimaryColor,
      child: Icon(
        icon,
      ),
    );
  }
}
