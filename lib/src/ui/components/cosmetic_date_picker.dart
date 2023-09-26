import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CosmeticDatePicker extends StatelessWidget {
  String inputText;
  Icon icon;
  double borderRadius;
  VoidCallback onTap;
  TextInputType keyboardType;
  MaskTextInputFormatter maskTextInputFormatter;
  FormFieldValidator? validator;
  TextEditingController? controller;
  TextInputAction? textInputAction;

  CosmeticDatePicker({
    super.key,
    required this.inputText,
    required this.icon,
    required this.borderRadius,
    required this.onTap,
    required this.keyboardType,
    required this.maskTextInputFormatter,
    this.validator,
    this.controller,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      controller: controller,
      validator: validator,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: [maskTextInputFormatter],
      decoration: InputDecoration(
        label: Text(inputText),
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        labelStyle: const TextStyle(
          color: cosmeticSecondaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            width: 2.0,
            color: cosmeticSecondaryColor,
          ),
        ),
      ),
    );
  }
}
