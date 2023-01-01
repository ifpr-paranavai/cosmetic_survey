import 'package:flutter/material.dart';

class CosmeticDropdown extends StatefulWidget {
  const CosmeticDropdown({Key? key}) : super(key: key);

  @override
  State<CosmeticDropdown> createState() => _CosmeticDropdownState();
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _CosmeticDropdownState extends State<CosmeticDropdown> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
