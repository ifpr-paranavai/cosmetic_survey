import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/constants/firebase_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUserData {
  static Stream<DocumentSnapshot> readUserData() {
    return FirebaseFirestore.instance
        .collection(FirebaseColletion.USER)
        .doc('2xSKrryaZicstAnRCDQE') //TODO Acessar o id do usuário logado de forma dinâmica
        .snapshots();
  }

  static String getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}
