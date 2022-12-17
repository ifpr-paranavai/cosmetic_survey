import 'package:cosmetic_survey/src/components/elevated_button.dart';
import 'package:cosmetic_survey/src/components/form_header_widget.dart';
import 'package:cosmetic_survey/src/constants/colors.dart';
import 'package:cosmetic_survey/src/constants/image_path.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../../components/text_form_field.dart';
import '../../../constants/sizes.dart';

class ForgetPasswordWidget extends StatelessWidget {
  ForgetPasswordWidget({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                FormHeaderWidget(
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
                        inputText: 'E-Mail',
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
                          buttonName: 'Enviar E-Mail',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
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
      ),
    );
  }
}
