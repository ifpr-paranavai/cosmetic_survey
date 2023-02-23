import 'package:cosmetic_survey/src/ui/authentication/welcome/welcome_widget.dart';
import 'package:cosmetic_survey/src/ui/verify_email/verify_email_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerifyEmailWidget();
          } else {
            return const WelcomeWidget();
          }
        },
      ),
    );
  }
}
