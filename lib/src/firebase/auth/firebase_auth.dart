import 'package:firebase_auth/firebase_auth.dart';

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

  static Future signIn({required String email, required String password}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  static Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
