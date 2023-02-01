import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/cosmetic_form_header_widget.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_path.dart';
import '../../../constants/sizes.dart';
import '../../../firebase/auth/google_auth.dart';
import '../signup/signup_widget.dart';
import 'login_form_widget.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

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
                image: cosmeticLoginImage,
                tittle: 'Bem vindo(a) de volta!',
                textStyleTittle: Theme.of(context).textTheme.headline5,
                subtittle: 'Faça login para continuar de onde parou.',
              ),
              CosmeticLoginFormWidget(),
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
                          builder: (context) => const SignUpWidget(),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Não possui uma conta? ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const TextSpan(
                            text: 'CADASTRE-SE',
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
