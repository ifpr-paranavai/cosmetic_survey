import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  CosmeticOrder order;
  VoidCallback onPressedDelete;

  OrderCard({
    Key? key,
    required this.order,
    required this.onPressedDelete,
  }) : super(key: key);

  final _random = Random();

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
          child: const Text('TEST'), //TODO ver qual informação colocar aqui
        ),
        title: const Text('Nome cliente'),
        subtitle: Text(
            'Valor total: R\$ ${order.totalValue}\nData da venda: ${Utils.formatDate(date: order.saleDate!)}'),
        onTap: () {},
        trailing: SizedBox(
          width: 50,
          child: Row(
            children: <Widget>[
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
