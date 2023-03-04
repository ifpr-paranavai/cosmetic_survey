import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class CosmeticDropdown extends StatefulWidget {
  String hintText = '';
  List<String> items = [];
  TextEditingController controller;

  CosmeticDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  State<CosmeticDropdown> createState() => _CosmeticDropdownState();
}

class _CosmeticDropdownState extends State<CosmeticDropdown> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown.search(
      hintText: widget.hintText,
      items: widget.items,
      controller: widget.controller,
      borderSide: const BorderSide(
        width: 0.6,
      ),
    );
  }
}
