import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:flutter/material.dart';

import '../firebase/firestore/customer_details.dart';
import 'cosmetic_snackbar.dart';

class CosmeticCard extends StatelessWidget {
  Customer customer;

  CosmeticCard({Key? key, required this.customer}) : super(key: key);

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
          child: Text(
            customer.name.toString().substring(0, 1).toUpperCase(),
          ),
        ),
        title: Text(customer.name),
        subtitle: Text(customer.cpfCnpj),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO
                  ScaffoldMessenger.of(context).showSnackBar(
                      CosmeticSnackBar.showSnackBar(
                          context: context, message: 'Teste chamada SnackBar'));
                },
              ),
              IconButton(
                icon:
                    const Icon(Icons.delete_forever_rounded, color: Colors.red),
                onPressed: () {
                  FirebaseCustomerDetails.deleteCustomerDetails(
                    id: customer.id,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
