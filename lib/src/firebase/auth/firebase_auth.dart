import 'package:cosmetic_survey/src/firebase/auth/firebase_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../authentication/welcome/welcome_widget.dart';
import '../../core/home/home_page_widget.dart';
import '../firestore/user_details.dart';

class FirebaseAuthentication {
  static Future signUp({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .then(
            (value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomePageWidget(),
                ),
                (Route<dynamic> route) => false,
              ),
            },
          );

      FirebaseUserDetails.addUserDetails(name: name, email: email);
    } on FirebaseAuthException catch (e) {
      FirebaseExceptions.catchFirebaseException(e.code);
    }
  }

  static Future signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .then(
            (value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomePageWidget(),
                ),
                (Route<dynamic> route) => false,
              ),
            },
          );
    } on FirebaseAuthException catch (e) {
      FirebaseExceptions.catchFirebaseException(e.code);
    }
  }

  static Future signOut({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut().then(
          (value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const WelcomeWidget(),
              ),
              (Route<dynamic> route) => false,
            ),
          },
        );
  }
}
