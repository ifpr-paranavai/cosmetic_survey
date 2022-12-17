import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CosmeticPasswordTextFormField extends StatefulWidget {
  String inputText;
  Icon icon;
  String? initialValue;
  double borderRadius;
  FormFieldValidator validator;

  CosmeticPasswordTextFormField({
    Key? key,
    required this.inputText,
    required this.icon,
    this.initialValue,
    required this.borderRadius,
    required this.validator,
  }) : super(key: key);

  @override
  State<CosmeticPasswordTextFormField> createState() =>
      _CosmeticTextFormFieldState();
}

class _CosmeticTextFormFieldState extends State<CosmeticPasswordTextFormField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
