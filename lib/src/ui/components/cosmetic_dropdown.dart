import 'package:cosmetic_survey/src/ui/utils/dropdown_style.dart';
import 'package:flutter/material.dart';

class CosmeticDropdown extends StatefulWidget {
  String hintText = '';
  List<String> items = [];
  ValueChanged<String> onItemChanged;
  FormFieldValidator validator;

  CosmeticDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    required this.onItemChanged,
    required this.validator,
  }) : super(key: key);

  @override
  State<CosmeticDropdown> createState() => _CosmeticDropdownState();
}

class _CosmeticDropdownState extends State<CosmeticDropdown> {
  var uiUtil = UiUtil();

  @override
  Widget build(BuildContext context) {
    String selectedItem;

    return DropdownButtonFormField<String>(
      value: null,
      decoration: uiUtil.dropdownStyle(label: widget.hintText),
      validator: widget.validator,
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? item) {
        setState(() {
          selectedItem = item!;
        });
        widget.onItemChanged(item!);
      },
    );
  }
}
