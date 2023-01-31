import 'dart:async';

import 'package:cosmetic_survey/src/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/components/cosmetic_outlined_button.dart';
import 'package:cosmetic_survey/src/core/home/home_page_widget.dart';
import 'package:cosmetic_survey/src/firebase/auth/firebase_auth.dart';
import 'package:cosmetic_survey/src/firebase/firestore/current_user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/image_path.dart';
import '../../constants/sizes.dart';

class VerifyEmailWidget extends StatefulWidget {
  const VerifyEmailWidget({Key? key}) : super(key: key);

  @override
  State<VerifyEmailWidget> createState() => _VerifyEmailWidgetState();
}

class _VerifyEmailWidgetState extends State<VerifyEmailWidget> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = CurrentUserDetails.isEmailVerified();

    if (!isEmailVerified) {
      FirebaseAuthentication.sendVerificationEmail(context: context);

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) {
          checkEmailVerified();
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return const HomePageWidget();
    } else {
      var deviceHeight = MediaQuery.of(context).size.height;

      return Scaffold(
        backgroundColor: cosmeticWhiteColor,
        body: Container(
          padding: const EdgeInsets.all(cosmeticDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: const AssetImage(
                  cosmeticSentEmail,
                ),
                height: deviceHeight * 0.4,
              ),
              Column(
                children: [
                  Text(
                    'E-Mail enviado!',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    'Verifique sua Caixa de entrada, Spam ou Lixeira.',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: cosmeticFormHeight),
                  SizedBox(
                    width: double.infinity,
                    child: CosmeticElevatedButton(
                      onPressed: () {
                        FirebaseAuthentication.sendVerificationEmail(
                            context: context);
                      },
                      buttonName: 'REENVIAR E-MAIL',
                    ),
                  ),
                  const SizedBox(height: cosmeticFormHeight - 10),
                  SizedBox(
                    width: double.infinity,
                    child: CosmeticOutlinedButton(
                      onPressed: () => FirebaseAuthentication.signOut(
                        context: context,
                      ),
                      buttonName: 'SAIR',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}