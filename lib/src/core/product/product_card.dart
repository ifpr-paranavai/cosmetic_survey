import 'dart:math';

import 'package:cosmetic_survey/src/core/product/product_actions.dart';
import 'package:flutter/material.dart';

import '../entity/product.dart';

class ProductCard extends StatelessWidget {
  Product product;
  VoidCallback onPressedDelete;

  ProductCard({
    Key? key,
    required this.product,
    required this.onPressedDelete,
  }) : super(key: key);

  final _random = Random();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
        title: Text(product.name),
        subtitle: Text('Código: ${product.code}'),
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
