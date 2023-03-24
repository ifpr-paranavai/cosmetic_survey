import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/brand.dart';
import 'package:flutter/material.dart';

import 'brand_actions.dart';

class BrandCard extends StatelessWidget {
  Brand brand;
  VoidCallback onPressedDelete;

  BrandCard({
    Key? key,
    required this.brand,
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
            brand.name.toString().substring(0, 1).toUpperCase(),
          ),
        ),
        onTap: () {
          BrandActions.showInfoDialog(context: context, brand: brand);
        },
        title: Text(brand.name),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => BrandActions.updateBrand(
                  context: context,
                  brand: brand,
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
