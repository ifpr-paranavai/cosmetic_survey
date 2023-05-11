import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_collection.dart';
import 'package:cosmetic_survey/src/ui/authentication/welcome/welcome_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CurrentUserDetails {
  Stream<DocumentSnapshot> readUserData() {
    return FirebaseFirestore.instance
        .collection(FirebaseCollection.USER)
        .doc(getCurrentUserUid())
        .snapshots();
  }

  User getCurrentUserFromGoogle() {
    return FirebaseAuth.instance.currentUser!;
  }

  String getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String getCurrentUserProvider() {
    return FirebaseAuth.instance.currentUser!.providerData.first.providerId;
  }

  bool isEmailVerified() {
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  String handleName(String userName) {
    var name = userName.split(' ');
    var firstName = name[0];
    var firstLetter = firstName.substring(0, 1).toUpperCase();
    var restOfTheName = firstName.substring(1).toLowerCase();

    return firstLetter + restOfTheName;
  }

  String getCurrentTime() {
    var currentTime = DateTime.now();

    if (currentTime.hour >= 6 && currentTime.hour < 12) {
      return 'Bom dia';
    } else if (currentTime.hour >= 12 && currentTime.hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  Future deleteAccount({required BuildContext context}) async {
    CurrentUserDetails currentUserDetails = CurrentUserDetails();

    return await FirebaseFirestore.instance
        .collection(FirebaseCollection.USER)
        .doc(currentUserDetails.getCurrentUserUid())
        .delete()
        .then(
          (value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const WelcomeWidget(),
              ),
              (Route<dynamic> route) => false,
            ),
            Fluttertoast.showToast(
              msg: 'Conta excluída. \nDesculpa se não fui bom o suficiente ;(',
              gravity: ToastGravity.BOTTOM,
            ),
          },
        );
  }

  String getCurrentUserCreationTime() {
    return DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
        .format(
            FirebaseAuth.instance.currentUser!.metadata.creationTime!.toLocal())
        .toString();
  }
}
