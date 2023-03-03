import 'package:cosmetic_survey/src/ui/authentication/welcome/welcome_widget.dart';
import 'package:cosmetic_survey/src/ui/verify_email/verify_email_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin({required BuildContext context}) async {
    await googleSignIn.signOut();

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    _user = googleUser;
    final googleAuth = await googleUser.authentication;

    final credential =
        GoogleAuthProvider.credential(accessToken: googleAuth.accessToken);

    await FirebaseAuth.instance.signInWithCredential(credential).then(
          (value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const VerifyEmailWidget(),
              ),
              (Route<dynamic> route) => false,
            ),
          },
        );
    notifyListeners();
  }

  Future googleLogout({required BuildContext context}) async {
    await GoogleSignIn().signOut().then(
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
