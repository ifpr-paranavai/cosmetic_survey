import 'package:cosmetic_survey/src/core/entity/brand.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class CosmeticBrandDropdown extends StatefulWidget {
  var brands = <Brand>[];

  CosmeticBrandDropdown({Key? key, required this.brands}) : super(key: key);

  @override
  State<CosmeticBrandDropdown> createState() => _CosmeticBrandDropdownState();
}

class _CosmeticBrandDropdownState extends State<CosmeticBrandDropdown> {
  @override
  Widget build(BuildContext context) {
    var selectedBrand = widget.brands.first;

    return DropdownButtonFormField<Brand>(
      value: selectedBrand,
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
      },
    );
  }
}
