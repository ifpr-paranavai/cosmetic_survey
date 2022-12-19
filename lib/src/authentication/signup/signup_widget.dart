import 'package:cosmetic_survey/src/components/cosmetic_form_header_widget.dart';
import 'package:cosmetic_survey/src/constants/colors.dart';
import 'package:flutter/material.dart';

import 'signup_form_widget.dart';
import '../../constants/image_path.dart';
import '../../constants/sizes.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

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
            padding: const EdgeInsets.all(
              cosmeticDefaultSize,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CosmeticFormHeaderWidget(
                  image: cosmeticFSignUpImage,
                  tittle: 'Boas vindas!',
                  textStyleTittle: Theme.of(context).textTheme.headline5,
                  subtittle: 'Crie seu perfil para começar sua jornada.',
                ),
                CosmeticSignUpFormWidget(),
                Column(
                  children: [
                    const Text('OU'),
                    const SizedBox(height: cosmeticFormHeight - 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        label: const Text(
                          'FAÇA LOGIN COM O GOOGLE',
                          style: TextStyle(
                            color: cosmeticSecondaryColor,
                          ),
                        ),
                        onPressed: () {},
                        icon: const Image(
                          image: AssetImage(
                            cosmeticGoogleLogoImage,
                          ),
                          width: 20.0,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Já possui uma conta? ',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const TextSpan(
                              text: 'LOGIN',
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
