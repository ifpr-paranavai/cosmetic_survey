import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';

class CosmeticElevatedButton extends StatelessWidget {
  final void Function() functionCallback;
  String buttonName;

  CosmeticElevatedButton(
      {Key? key, required this.buttonName, required this.functionCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        functionCallback;
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: const RoundedRectangleBorder(),
        foregroundColor: cosmeticWhiteColor,
        backgroundColor: cosmeticSecondaryColor,
        side: const BorderSide(color: cosmeticSecondaryColor),
        padding: const EdgeInsets.symmetric(vertical: cosmeticButtonHeight),
      ),
      child: Text(buttonName),
    );
  }
}
