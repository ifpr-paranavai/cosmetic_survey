import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class UiUtil {
  InputDecoration dropdownStyle({required String label}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelStyle: const TextStyle(
        color: cosmeticSecondaryColor,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          width: 2.0,
          color: cosmeticSecondaryColor,
        ),
      ),
    );
  }
}
