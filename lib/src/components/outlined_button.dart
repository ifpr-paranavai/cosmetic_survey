import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';

class CosmeticOutlinedButton extends StatelessWidget {
  final void Function() functionCallback;
  String buttonName;

  CosmeticOutlinedButton(
      {Key? key, required this.buttonName, required this.functionCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        functionCallback;
      },
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        foregroundColor: cosmeticSecondaryColor,
        side: const BorderSide(color: cosmeticSecondaryColor),
        padding: const EdgeInsets.symmetric(vertical: cosmeticButtonHeight),
      ),
      child: Text(buttonName),
    );
  }
}
