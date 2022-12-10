import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CosmeticTextFormField extends StatelessWidget {
  String inputText;
  Icon icon;
  TextInputType keyboardType;

  CosmeticTextFormField(
      {Key? key,
      required this.inputText,
      required this.icon,
      required this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Text(inputText),
        prefixIcon: icon,
        border: const OutlineInputBorder(),
        labelStyle: const TextStyle(
          color: cosmeticSecondaryColor,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: cosmeticSecondaryColor,
          ),
        ),
      ),
    );
  }
}
