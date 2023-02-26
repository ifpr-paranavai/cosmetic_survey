import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class CosmeticDropdown extends StatefulWidget {
  String hintText = '';
  List<String> options = [];

  CosmeticDropdown({
    Key? key,
    required this.options,
    required this.hintText,
  }) : super(key: key);

  @override
  State<CosmeticDropdown> createState() => _CosmeticDropdownState();
}

class _CosmeticDropdownState extends State<CosmeticDropdown> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomDropdown.search(
      hintText: widget.hintText,
      items: widget.options,
      controller: textController,
      borderSide: const BorderSide(
        width: 0.6,
      ),
    );
  }
}
