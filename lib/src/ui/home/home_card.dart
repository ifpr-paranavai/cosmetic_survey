import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  String? value;
  int? quantity;
  String description;
  bool amountValue;
  bool hideValue;

  HomeCard({
    Key? key,
    this.value,
    this.quantity,
    required this.description,
    required this.amountValue,
    required this.hideValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(7),
      child: ListTile(
        title: Text(
          amountValue
              ? 'R\$ ${hideValue ? value : '***'}'
              : 'Qtd. ${hideValue ? quantity : '***'}',
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
