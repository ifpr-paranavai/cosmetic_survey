import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  late VoidCallback onTap;

  ReportCard({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Card(
        margin: EdgeInsets.all(7),
        child: ListTile(
          title: Text(
            'GERAR RELATÓRIO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
