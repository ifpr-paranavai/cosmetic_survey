import 'package:flutter/material.dart';

import '../navigation-bar/navigation-bar-widget.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const CosmeticBottomNavigationBar(),
        body: SingleChildScrollView(
          child: Container(),
        ),
      ),
    );
  }
}
