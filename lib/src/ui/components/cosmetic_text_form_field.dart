import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CosmeticTextFormField extends StatelessWidget {
  String inputText;
  Icon icon;
  TextInputType keyboardType;
  String? initialValue;
  double borderRadius;
  FormFieldValidator? validator;
  TextEditingController? controller;
  TextInputAction? textInputAction;

  CosmeticTextFormField({
    Key? key,
    required this.inputText,
    required this.icon,
    required this.keyboardType,
    required this.borderRadius,
    this.validator,
    this.initialValue,
    this.controller,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      validator: validator,
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
