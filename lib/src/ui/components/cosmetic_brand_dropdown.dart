import 'package:cosmetic_survey/src/core/entity/brand.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class CosmeticBrandDropdown extends StatefulWidget {
  var brands = <Brand>[];
  ValueChanged<Brand> onBrandChanged;

  CosmeticBrandDropdown({
    Key? key,
    required this.brands,
    required this.onBrandChanged,
  }) : super(key: key);

  @override
  State<CosmeticBrandDropdown> createState() => _CosmeticBrandDropdownState();
}

class _CosmeticBrandDropdownState extends State<CosmeticBrandDropdown> {
  @override
  Widget build(BuildContext context) {
    Brand selectedBrand;

    return DropdownButtonFormField<Brand>(
      value: null,
      decoration: InputDecoration(
        labelText: 'Selecione uma Marca',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelStyle: const TextStyle(
          color: cosmeticSecondaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            width: 2.0,
            color: cosmeticSecondaryColor,
          ),
        ),
      ),
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
