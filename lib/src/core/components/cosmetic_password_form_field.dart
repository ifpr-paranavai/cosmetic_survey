import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CosmeticPasswordFormField extends StatefulWidget {
  String inputText;
  Icon icon;
  String? initialValue;
  double borderRadius;
  FormFieldValidator validator;
  TextEditingController? controller;
  TextInputAction? textInputAction;

  CosmeticPasswordFormField({
    Key? key,
    required this.inputText,
    required this.icon,
    this.initialValue,
    required this.borderRadius,
    required this.validator,
    this.controller,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<CosmeticPasswordFormField> createState() =>
      _CosmeticPasswordFormField();
}

class _CosmeticPasswordFormField extends State<CosmeticPasswordFormField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      initialValue: widget.initialValue,
      keyboardType: TextInputType.visiblePassword,
      validator: widget.validator,
      decoration: InputDecoration(
        label: Text(
          widget.inputText,
        ),
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
        suffixIcon: IconButton(
          icon: Icon(
            _hidePassword ? Icons.visibility : Icons.visibility_off,
          ),
          color: cosmeticSecondaryColor,
          onPressed: () {
            setState(
              () {
                _hidePassword = !_hidePassword;
              },
            );
          },
        ),
      ),
      obscureText: _hidePassword,
    );
  }
}
