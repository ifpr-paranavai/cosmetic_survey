import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class CosmeticDropdown extends StatefulWidget {
  const CosmeticDropdown({Key? key}) : super(key: key);

  //TODO passar a lista de itens como parâmetro para que seja um componente genérico

  @override
  State<CosmeticDropdown> createState() => _CosmeticDropdownState();
}

class _CosmeticDropdownState extends State<CosmeticDropdown> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomDropdown.search(
      hintText: 'Selecione uma Marca',
      items: const ['Developer', 'Designer', 'Consultant', 'Student'],
      // items: BrandDetails.readBrandNames(),
      controller: textController,
      borderSide: const BorderSide(
        width: 0.6,
      ),
    );
  }
}
