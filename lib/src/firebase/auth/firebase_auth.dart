import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/home/home_page_widget.dart';
import '../firestore/user_details.dart';

//TODO tratamento de erros
class FirebaseAuthentication {
  static Future signUp({required String name, required String email, required String password}) async {

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    FirebaseUserDetails.addUserDetails(name: name, email: email);
  }

  static Future signIn({required String email, required String password, required BuildContext context}) async {
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
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'E-Mail não encontrado.',
          gravity: ToastGravity.BOTTOM
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'E-Mail ou Senha incorretos.',
          gravity: ToastGravity.BOTTOM,
        );
      } else if (e.code == 'too-many-requests'){
        Fluttertoast.showToast(
          msg: 'Você tentou fazer login muitas vezes seguidas. Aguarde um instante e tente novamente.',
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  static Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
