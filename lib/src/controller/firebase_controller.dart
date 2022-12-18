import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/constants/firebase_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO tratamento de erros
class FirebaseController {
  static Future signUp(
      {required String name,
      required String email,
      required String password}) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    addUserDetails(name: name, email: email);
  }

  static Future signIn(
      {required String email, required String password}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  static Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future addUserDetails(
      {required String name, required String email}) async {
    await FirebaseFirestore.instance.collection(FirebaseColletion.USER).add(
      {
        'name': name.trim(),
        'email': email.trim(),
      },
    );
  }
}
