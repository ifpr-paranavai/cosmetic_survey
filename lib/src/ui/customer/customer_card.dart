import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:flutter/material.dart';

import 'customer_actions.dart';

class CustomerCard extends StatelessWidget {
  Customer customer;
  VoidCallback onPressedDelete;

  CustomerCard({
    Key? key,
    required this.customer,
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
            customer.name.toString().substring(0, 1).toUpperCase(),
          ),
        ),
        onTap: () {
          CustomerActions.showInfoDialog(context: context, customer: customer);
        },
        title: Text(customer.name),
        subtitle: Text('CPF: ${customer.cpf}'),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => CustomerActions.updateCustomer(
                  context: context,
                  customer: customer,
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
