import 'package:cosmetic_survey/src/components/cosmetic_form_header_widget.dart';
import 'package:cosmetic_survey/src/constants/colors.dart';
import 'package:cosmetic_survey/src/firebase/auth/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/image_path.dart';
import '../../../constants/sizes.dart';
import '../login/login_widget.dart';
import 'signup_form_widget.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

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
                        'ENTRAR COM O GOOGLE',
                        style: TextStyle(
                          color: cosmeticSecondaryColor,
                        ),
                      ),
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false,
                        );
                        provider.googleLogin(context: context);
                      },
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginWidget(),
                        ),
                      );
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
    );
  }
}
