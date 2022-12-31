import 'package:cosmetic_survey/src/constants/colors.dart';
import 'package:cosmetic_survey/src/core/profile/profile_widget.dart';
import 'package:flutter/material.dart';

import '../customer/customer_widget.dart';

class CosmeticBottomNavigationBar extends StatefulWidget {
  const CosmeticBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CosmeticBottomNavigationBar> createState() =>
      _CosmeticBottomNavigationBarState();
}

class _CosmeticBottomNavigationBarState
    extends State<CosmeticBottomNavigationBar> {
  int index = 0;

  final screens = [
    const Center(
      child: Text(
        'Inicio',
        style: TextStyle(fontSize: 30),
      ),
    ),
    const Center(
      child: Text(
        'Pedidos',
        style: TextStyle(fontSize: 30),
      ),
    ),
    const Center(
      child: Text(
        'Marcas',
        style: TextStyle(fontSize: 30),
      ),
    ),
    const CustomerWidget(),
    const ProfileWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: cosmeticPrimaryColor.withOpacity(.2),
          height: 60,
          elevation: 10,
          backgroundColor: Colors.white,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.black26,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.black26,
              ),
              label: 'Início',
              selectedIcon: Icon(
                Icons.home,
                color: cosmeticPrimaryColor,
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.list_alt_outlined,
                color: Colors.black26,
              ),
              label: 'Pedidos',
              selectedIcon: Icon(
                Icons.list_alt_rounded,
                color: cosmeticPrimaryColor,
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.branding_watermark_outlined,
                color: Colors.black26,
              ),
              label: 'Marcas',
              selectedIcon: Icon(
                Icons.branding_watermark_rounded,
                color: cosmeticPrimaryColor,
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.supervisor_account_outlined,
                color: Colors.black26,
              ),
              label: 'Clientes',
              selectedIcon: Icon(
                Icons.supervisor_account,
                color: cosmeticPrimaryColor,
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.black26,
              ),
              label: 'Conta',
              selectedIcon: Icon(
                Icons.account_circle_rounded,
                color: cosmeticPrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
