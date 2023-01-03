import 'package:cosmetic_survey/src/components/cosmetic_password_form_field.dart';
import 'package:cosmetic_survey/src/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/core/home/home_page_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../components/cosmetic_elevated_button.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../firebase/auth/firebase_auth.dart';

class CosmeticSignUpFormWidget extends StatelessWidget {
  CosmeticSignUpFormWidget({
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String name = '';
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
            CosmeticTextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              borderRadius: 10,
              keyboardType: TextInputType.name,
              inputText: 'Nome',
              icon: const Icon(
                Icons.person_outline_rounded,
                color: cosmeticSecondaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o Nome!';
                } else {
                  name = value;
                }
                return null;
              },
            ),
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
                } else {
                  password = value;
                }
                return null;
              },
            ),
            const SizedBox(height: cosmeticFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: CosmeticElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {
                      FirebaseAuthentication.signUp(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context
                      ),
                    },
                },
                buttonName: 'CRIAR CONTA',
              ),
            )
          ],
        ),
      ),
    );
  }
}
