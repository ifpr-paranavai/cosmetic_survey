import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CosmeticDatePicker extends StatefulWidget {
  String inputText;
  Icon icon;
  double borderRadius;
  VoidCallback onTap;
  FormFieldValidator? validator;
  TextEditingController? controller;
  TextInputAction? textInputAction;

  CosmeticDatePicker({
    super.key,
    required this.inputText,
    required this.icon,
    required this.borderRadius,
    required this.onTap,
    this.validator,
    this.controller,
    this.textInputAction,
  });

  @override
  State<CosmeticDatePicker> createState() => _CosmeticDatePickerState();
}

class _CosmeticDatePickerState extends State<CosmeticDatePicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      validator: widget.validator,
      onTap: widget.onTap,
      decoration: InputDecoration(
        label: Text(widget.inputText),
        prefixIcon: widget.icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        labelStyle: const TextStyle(
          color: cosmeticSecondaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(
            width: 2.0,
            color: cosmeticSecondaryColor,
          ),
        ),
      ),
    );
  }
}
