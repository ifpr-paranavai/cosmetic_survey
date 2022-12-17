import 'package:cosmetic_survey/src/components/password_text_form_field.dart';
import 'package:cosmetic_survey/src/components/text_form_field.dart';
import 'package:cosmetic_survey/src/core/home/home-page-widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../authentication/forget-password/forget-password-email/forget-password-widget.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import 'elevated_button.dart';

class CosmeticLoginFormWidget extends StatelessWidget {
  CosmeticLoginFormWidget({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: cosmeticFormHeight - 10,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: cosmeticFormHeight - 20),
            CosmeticTextFormField(
              borderRadius: 10,
              keyboardType: TextInputType.emailAddress,
              inputText: 'E-Mail',
              icon: const Icon(
                Icons.email_outlined,
                color: cosmeticSecondaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o E-Mail!';
                }
                if (EmailValidator.validate(value)) {
                  email = value;
                } else {
                  return 'E-Mail inválido!';
                }
                return null;
              },
            ),
            const SizedBox(height: cosmeticFormHeight - 20),
            CosmeticPasswordTextFormField(
              borderRadius: 10,
              icon: const Icon(
                Icons.fingerprint_rounded,
                color: cosmeticSecondaryColor,
              ),
              inputText: 'Senha',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a Senha!';
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgetPasswordWidget(),
                  ),
                );
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
                  if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePageWidget(),
                        ),
                      ),
                    },
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
