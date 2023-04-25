import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/customer_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  CosmeticOrder order;
  VoidCallback onPressedDelete;
  List<Customer> customers;

  OrderCard({
    Key? key,
    required this.order,
    required this.onPressedDelete,
    required this.customers,
  }) : super(key: key);

  final _random = Random();
  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
  var customerDetails = CustomerDetails();

  @override
  Widget build(BuildContext context) {
    final formattedValue = formatter.format(order.totalValue);

    var customerName = customerDetails.getCustomerName(
      customers: customers,
      customerId: order.customerId,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.primaries[_random.nextInt(Colors.primaries.length)]
                  [_random.nextInt(9) * 100],
          child: Text(customerName.substring(0, 1).toUpperCase()),
        ),
        title: Text('Cliente: $customerName'),
        subtitle: Text(
            'Valor total: R\$$formattedValue\nCiclo: ${order.cicle}\nData da venda: ${Utils.formatDate(date: order.saleDate!)}'),
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
