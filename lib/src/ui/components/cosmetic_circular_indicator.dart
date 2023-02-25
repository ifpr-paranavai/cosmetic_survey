import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CosmeticCircularIndicator extends StatelessWidget {
  const CosmeticCircularIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: cosmeticPrimaryColor,
      ),
    );
  }
}
