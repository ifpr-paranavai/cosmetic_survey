import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'src/authentication/welcome/welcome_widget.dart';
import 'src/core/home/home_page_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePageWidget();
          } else {
            return const WelcomeWidget();
          }
        },
      ),
    );
  }
}
