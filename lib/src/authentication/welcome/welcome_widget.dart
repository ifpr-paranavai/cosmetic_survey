import 'package:cosmetic_survey/src/constants/colors.dart';
import 'package:cosmetic_survey/src/constants/image_path.dart';
import 'package:cosmetic_survey/src/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../components/elevated_button.dart';
import '../../components/outlined_button.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: cosmeticPrimaryColor,
        body: Container(
          padding: const EdgeInsets.all(cosmeticDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: const AssetImage(tWelcomeScreenImage),
                height: deviceHeight * 0.6,
              ),
              Column(
                children: [
                  Text(
                    'Cosmetic Survey',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  // TODO mudar slogan
                  Text(
                    'Gerencie suas revendas em um só lugar!',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CosmeticOutlinedButton(
                      buttonName: 'LOGIN',
                      functionCallback: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: CosmeticElevatedButton(
                      buttonName: 'ENTRAR',
                      functionCallback: () {},
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
