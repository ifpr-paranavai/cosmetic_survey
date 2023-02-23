import 'package:cosmetic_survey/src/core/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_password_form_field.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/firebase/auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../forget_password/forget_password_widget.dart';

class CosmeticLoginFormWidget extends StatelessWidget {
  CosmeticLoginFormWidget({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              controller: _emailController,
              textInputAction: TextInputAction.next,
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
            CosmeticPasswordFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
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
                buttonName: 'ENTRAR',
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {
                      FirebaseAuthentication.signIn(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context,
                      ),
                    },
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
