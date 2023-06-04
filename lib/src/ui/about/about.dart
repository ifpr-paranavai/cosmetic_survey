import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:flutter/material.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(cosmeticDefaultSize),
          child: writeDescription(context),
        ),
      ),
    );
  }

  Column writeDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descrição do Aplicativo:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        const Text(
          'O aplicativo Cosmetic Survey foi desenvolvido por Andrey Silva Cordeiro '
          'como parte de seu projeto de Trabalho de Conclusão de Curso (TCC) no '
          'curso de Engenharia de Software pelo Instituto Federal do Paraná, Campus Paranavaí. '
          'Sob a orientação do Prof. Me. Helio Toshio Kamakawa, com o intuito de '
          'proporcionar uma solução inovadora e eficiente para atender às necessidades dos usuários. '
          'O aplicativo destaca-se pela sua proposta inovadora e está sendo desenvolvido com grande entusiasmo e dedicação, '
          'e espera-se que possa contribuir positivamente para a vida dos usuários, fornecendo uma experiência única e satisfatória. '
          'Agradecemos por utilizar o aplicativo Cosmetic Survey e esperamos que ele seja útil e traga benefícios significativos para sua vida.',
          style: TextStyle(
            fontSize: 16.0,
          ),
          textAlign: TextAlign.justify,
        ),
        const Divider(height: 50),
        const SizedBox(height: 20.0),
        SizedBox(
          width: double.infinity,
          child: CosmeticElevatedButton(
            buttonName: 'VOLTAR',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => {
          Navigator.pop(context),
        },
        icon: const Icon(Icons.arrow_back_outlined),
        color: cosmeticSecondaryColor,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Sobre o aplicativo',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cosmeticSecondaryColor,
          fontSize: 25,
        ),
      ),
    );
  }
}
