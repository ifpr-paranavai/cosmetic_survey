import 'package:cosmetic_survey/src/components/password_text_form_field.dart';
import 'package:cosmetic_survey/src/components/text_form_field.dart';
import 'package:cosmetic_survey/src/core/home/home-page-widget.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import 'elevated_button.dart';

class CosmeticLoginFormWidget extends StatelessWidget {
  const CosmeticLoginFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: cosmeticFormHeight - 10,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: cosmeticFormHeight - 20),
            CosmeticTextFormField(
              keyboardType: TextInputType.emailAddress,
              inputText: 'E-Mail',
              icon: const Icon(
                Icons.email_outlined,
                color: cosmeticSecondaryColor,
              ),
            ),
            const SizedBox(height: cosmeticFormHeight - 20),
            CosmeticPasswordTextFormField(
              icon: const Icon(
                Icons.fingerprint_rounded,
                color: cosmeticSecondaryColor,
              ),
              inputText: 'Senha',
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Esqueceu a Senha?',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: cosmeticFormHeight - 25),
            SizedBox(
              width: double.infinity,
              child: CosmeticElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePageWidget(),
                    ),
                  )
                },
                buttonName: 'ENTRAR',
              ),
            )
          ],
        ),
      ),
    );
  }
}
