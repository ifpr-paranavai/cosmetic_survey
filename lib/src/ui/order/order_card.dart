import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/order.dart';
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
            order.products.first.name.toString().substring(0, 1).toUpperCase(),
          ),
        ),
        title: Text(order.products.first.name),
        // subtitle: Text(
        //     //TODO formatar valor
        //     'Valor total: R\$ ${order.totalValue} | Qtd. de Itens: ${order.products.length}'),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined),
                onPressed: () => {
                  //TODO tela para visualizar pedido (não deve dar a possibilidade de alterar nada)
                },
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
