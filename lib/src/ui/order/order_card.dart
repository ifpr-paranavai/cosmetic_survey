import 'dart:math';

import 'package:cosmetic_survey/src/core/constants/order_status.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/customer_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/order/view_update_order_details.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  CosmeticOrder order;
  VoidCallback? onPressedDelete;
  List<Customer> customers;
  bool? isReport;

  OrderCard({
    Key? key,
    required this.order,
    this.onPressedDelete,
    required this.customers,
    this.isReport,
  }) : super(key: key);

  final _random = Random();
  var customerDetails = CustomerDetails();
  var utils = Utils();

  @override
  Widget build(BuildContext context) {
    //TODO  mudar a forma que é feito esse vínculo
    var customerName = customerDetails.getCustomerName(
      customers: customers,
      customerId: order.customerId,
    );

    if (isReport != null && isReport == true) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                Colors.primaries[_random.nextInt(Colors.primaries.length)]
                    [_random.nextInt(9) * 100],
            child: Text(
              customerName != null
                  ? customerName.substring(0, 1).toUpperCase()
                  : '',
            ),
          ),
          title: Text(
            customerName ?? 'Erro ao carregar Nome',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Valor total: R\$ ${utils.formatToBrazilianCurrency(order.totalValue!)}'
            '\nCiclo: ${order.cicle}'
            '\nData da venda: ${Utils.formatDateDDMMYYYY(date: order.saleDate!)}'
            '\nSituação: ${order.missingValue! > 0 ? OrderStatus.EM_ANDAMENTO : OrderStatus.PAGO}',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewUpdateOrderDetails(orderId: order.id),
              ),
            );
          },
        ),
      );
    } else {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                Colors.primaries[_random.nextInt(Colors.primaries.length)]
                    [_random.nextInt(9) * 100],
            child: Text(
              customerName != null
                  ? customerName.substring(0, 1).toUpperCase()
                  : '',
            ),
          ),
          title: Text(
            customerName ?? 'Erro ao carregar Nome',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Valor total: R\$ ${utils.formatToBrazilianCurrency(order.totalValue!)}'
            '\nCiclo: ${order.cicle}'
            '\nData da venda: ${Utils.formatDateDDMMYYYY(date: order.saleDate!)}'
            '\nSituação: ${order.missingValue! > 0 ? OrderStatus.EM_ANDAMENTO : OrderStatus.PAGO}',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewUpdateOrderDetails(orderId: order.id),
              ),
            );
          },
          trailing: SizedBox(
            width: 50,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.delete_forever_rounded,
                      color: Colors.red),
                  onPressed: onPressedDelete,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
