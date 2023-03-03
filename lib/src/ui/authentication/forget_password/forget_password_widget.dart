import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/image_path.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/firebase/auth/firebase_auth.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_form_header_widget.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ForgetPasswordWidget extends StatelessWidget {
  ForgetPasswordWidget({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cosmeticWhiteColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: cosmeticPrimaryColor,
        ),
      ),
      backgroundColor: cosmeticWhiteColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(cosmeticDefaultSize),
          child: Column(
            children: [
              const SizedBox(height: cosmeticDefaultSize),
              CosmeticFormHeaderWidget(
                image: cosmeticForgetPasswordImage,
                tittle: 'Esqueceu a senha?',
                subtittle: 'Informe o email para recuperá-la!',
                crossAxisAlignment: CrossAxisAlignment.center,
                heightBetween: 30.0,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: cosmeticFormHeight),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CosmeticTextFormField(
                      icon: const Icon(
                        Icons.email_outlined,
                        color: cosmeticSecondaryColor,
                      ),
                      controller: _emailController,
                      inputText: 'E-Mail',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      borderRadius: 10.0,
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
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: CosmeticElevatedButton(
                        buttonName: 'ENVIAR E-MAIL',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            firebaseAuthentication.resetPassword(
                              email: _emailController.text,
                              context: context,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
