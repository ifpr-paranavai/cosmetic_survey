import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../components/password_text_form_field.dart';
import '../../components/text_form_field.dart';
import '../../constants/colors.dart';
import '../../constants/image_path.dart';
import '../../constants/sizes.dart';

class UpdateProfileWidget extends StatelessWidget {
  const UpdateProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {
              Navigator.pop(context),
            },
            icon: const Icon(LineAwesomeIcons.angle_left),
            color: cosmeticSecondaryColor,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Editar Perfil',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cosmeticSecondaryColor,
              fontSize: 25,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(cosmeticDefaultSize),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                          image: AssetImage(
                            cosmeticUserProfileImage,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: cosmeticPrimaryColor,
                        ),
                        //TODO IconButton para chamar a função de escolher a imagem de perfil
                        child: const Icon(
                          LineAwesomeIcons.camera,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Form(
                  child: Column(
                    children: [
                      CosmeticTextFormField(
                        borderRadius: 100,
                        keyboardType: TextInputType.name,
                        inputText: 'Nome',
                        icon: const Icon(
                          Icons.person_outline_rounded,
                          color: cosmeticSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: cosmeticFormHeight - 20),
                      CosmeticTextFormField(
                        borderRadius: 100,
                        keyboardType: TextInputType.emailAddress,
                        inputText: 'E-Mail',
                        icon: const Icon(
                          Icons.email_outlined,
                          color: cosmeticSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: cosmeticFormHeight - 20),
                      CosmeticPasswordTextFormField(
                        borderRadius: 100,
                        icon: const Icon(
                          Icons.fingerprint_rounded,
                          color: cosmeticSecondaryColor,
                        ),
                        inputText: 'Senha',
                      ),
                      const SizedBox(height: cosmeticFormHeight),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cosmeticPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Salvar',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: cosmeticFormHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //TODO informar a data da criação da conta do Usuário
                        children: [
                          const Text.rich(
                            TextSpan(
                              text: 'Entrou em ',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: '14 de Dezembro de 2022',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none,
                            ),
                            child: const Text('Excluir'),
                          ),
                        ],
                      )
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
