import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/order/view_update_payment_details.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatefulWidget {
  CosmeticOrder order;
  Payment payment;

  PaymentCard({
    Key? key,
    required this.order,
    required this.payment,
  }) : super(key: key);

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
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
          child: Text('${widget.payment.installmentNumber}'),
        ),
        title: Text(
            'Pagamento referente à ${widget.payment.installmentNumber}ª parcela'),
        subtitle: widget.payment.paymentDate != null
            ? Text(
                'Data de pagamento: ${Utils.formatDate(date: widget.payment.paymentDate!)}')
            : const Text(
                'Pagamento pendente.',
              ),
        onTap: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewUpdatePaymentDetails(
                order: widget.order,
                payment: widget.payment,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              widget.payment.paymentDate = result;
            });
          }
        },
      ),
    );
  }
}
