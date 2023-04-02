import 'package:cosmetic_survey/src/core/entity/brand.dart';
import 'package:cosmetic_survey/src/ui/utils/dropdown_style.dart';
import 'package:flutter/material.dart';

class CosmeticBrandDropdown extends StatefulWidget {
  var brands = <Brand>[];
  ValueChanged<Brand> onBrandChanged;
  FormFieldValidator validator;

  CosmeticBrandDropdown({
    Key? key,
    required this.brands,
    required this.onBrandChanged,
    required this.validator,
  }) : super(key: key);

  @override
  State<CosmeticBrandDropdown> createState() => _CosmeticBrandDropdownState();
}

class _CosmeticBrandDropdownState extends State<CosmeticBrandDropdown> {
  var uiUtil = UiUtil();

  @override
  Widget build(BuildContext context) {
    Brand selectedBrand;

    return DropdownButtonFormField<Brand>(
      value: null,
      decoration: uiUtil.dropdownStyle(label: 'Selecione uma Marca'),
      validator: widget.validator,
      items: widget.brands.map((Brand brand) {
        return DropdownMenuItem<Brand>(
          value: brand,
          child: Text(brand.name),
        );
      }).toList(),
      onChanged: (Brand? brand) {
        setState(() {
          selectedBrand = brand!;
        });
        widget.onBrandChanged(brand!);
      },
    );
  }
}
