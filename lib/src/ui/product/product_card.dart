import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/brand_details.dart';
import 'package:cosmetic_survey/src/ui/product/product_actions.dart';
import 'package:flutter/material.dart';

import '../../core/entity/brand.dart';

class ProductCard extends StatelessWidget {
  Product product;
  VoidCallback onPressedDelete;
  List<Brand> brands;

  ProductCard({
    Key? key,
    required this.product,
    required this.onPressedDelete,
    required this.brands,
  }) : super(key: key);

  final _random = Random();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BrandDetails brandDetails = BrandDetails();

  @override
  Widget build(BuildContext context) {
    var brand = brandDetails.getBrandName(
      brands: brands,
      brandId: product.brandId,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.primaries[_random.nextInt(Colors.primaries.length)]
                  [_random.nextInt(9) * 100],
          child: Text(
            product.name.toString().substring(0, 1).toUpperCase(),
          ),
        ),
        onTap: () {
          ProductActions.showInfoDialog(
              context: context, product: product, brand: brand);
        },
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('Código: ${product.code}\nMarca: $brand'),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => ProductActions.updateProduct(
                  context: context,
                  product: product,
                  formKey: _formKey,
                  brands: brands,
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.delete_forever_rounded, color: Colors.red),
                onPressed: onPressedDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
