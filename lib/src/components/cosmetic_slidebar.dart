import 'package:flutter/material.dart';

class CosmeticSlideBar extends StatelessWidget {
  const CosmeticSlideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey,
        ),
        margin: const EdgeInsets.all(8.0),
        height: 5.0,
        width: 50.0,
      ),
    );
  }
}
