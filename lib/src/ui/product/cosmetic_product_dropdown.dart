import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/ui/utils/dropdown_style.dart';
import 'package:flutter/material.dart';

class CosmeticProductDropdown extends StatefulWidget {
  var products = <Product>[];
  ValueChanged<Product> onProductChanged;
  FormFieldValidator validator;

  CosmeticProductDropdown({
    Key? key,
    required this.products,
    required this.onProductChanged,
    required this.validator,
  }) : super(key: key);

  @override
  State<CosmeticProductDropdown> createState() =>
      _CosmeticProductDropdownState();
}

class _CosmeticProductDropdownState extends State<CosmeticProductDropdown> {
  var uiUtil = UiUtil();

  @override
  Widget build(BuildContext context) {
    Product selectedProduct;

    return DropdownButtonFormField<Product>(
      value: null,
      decoration: uiUtil.dropdownStyle(label: 'Selecione um Produto'),
      validator: widget.validator,
      items: widget.products.map((Product product) {
        return DropdownMenuItem<Product>(
          value: product,
          child: Text(product.name),
        );
      }).toList(),
      onChanged: (Product? product) {
        setState(() {
          selectedProduct = product!;
        });
        widget.onProductChanged(product!);
      },
    );
  }
}
