import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  double? value;
  int? quantity;
  String description;
  bool amountValue;

  HomeCard({
    Key? key,
    this.value,
    this.quantity,
    required this.description,
    required this.amountValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(7),
      child: ListTile(
        title: Text(
          amountValue ? 'R\$ $value' : 'Qtd. $quantity',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          description,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
