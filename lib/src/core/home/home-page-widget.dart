import 'package:cosmetic_survey/src/core/bottom-navigation-bar/bottom-%20navigation-bar-widget.dart';
import 'package:flutter/material.dart';

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
