import 'package:cosmetic_survey/src/core/verify_email/verify_email_widget.dart';
import 'package:cosmetic_survey/src/firebase/auth/firebase_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/authentication/welcome/welcome_widget.dart';
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
                  builder: (context) => const VerifyEmailWidget(),
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
                  builder: (context) => const VerifyEmailWidget(),
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

  static Future resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
            email: email.trim(),
          )
          .then(
            (value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const WelcomeWidget(),
                ),
                (Route<dynamic> route) => false,
              ),
            },
          );
      Fluttertoast.showToast(
        msg: 'E-Mail para recuperação de senha enviado.',
        gravity: ToastGravity.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'E-Mail não encontrado.',
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  static Future sendVerificationEmail({required BuildContext context}) async {
    try {
      return await FirebaseAuth.instance.currentUser!
          .sendEmailVerification()
          .then(
            (value) => {
              Fluttertoast.showToast(
                msg: 'E-Mail enviado.',
                gravity: ToastGravity.BOTTOM,
              ),
            },
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        return Fluttertoast.showToast(
          msg:
              'Um E-Mail já foi enviado. Aguarde um instante para enviá-lo novamente.',
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Ocorreu um erro. Código: ${e.code}',
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }
}
