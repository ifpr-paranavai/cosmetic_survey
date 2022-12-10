import 'package:cosmetic_survey/src/components/password_text_form_field.dart';
import 'package:cosmetic_survey/src/components/text_form_field.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import 'elevated_button.dart';

class CosmeticSignUpFormWidget extends StatelessWidget {
  const CosmeticSignUpFormWidget({
    Key? key,
  }) : super(key: key);

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
            CosmeticTextFormField(
              keyboardType: TextInputType.name,
              inputText: 'Nome',
              icon: const Icon(
                Icons.person_outline_rounded,
                color: cosmeticSecondaryColor,
              ),
            ),
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
            const SizedBox(height: cosmeticFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: CosmeticElevatedButton(
                onPressed: () => {},
                buttonName: 'CRIAR CONTA',
              ),
            )
          ],
        ),
      ),
    );
  }
}
