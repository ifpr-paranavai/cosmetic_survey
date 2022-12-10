import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CosmeticPasswordTextFormField extends StatefulWidget {
  String inputText;
  Icon icon;

  CosmeticPasswordTextFormField(
      {Key? key, required this.inputText, required this.icon})
      : super(key: key);

  @override
  State<CosmeticPasswordTextFormField> createState() =>
      _CosmeticTextFormFieldState();
}

class _CosmeticTextFormFieldState extends State<CosmeticPasswordTextFormField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        label: Text(
          widget.inputText,
        ),
        prefixIcon: widget.icon,
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
