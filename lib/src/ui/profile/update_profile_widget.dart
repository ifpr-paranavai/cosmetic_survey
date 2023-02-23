import 'package:cosmetic_survey/src/core/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_password_form_field.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/image_path.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileWidget extends StatelessWidget {
  CurrentUser user;

  UpdateProfileWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';

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
                  key: _formKey,
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
                        borderRadius: 100,
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
                        borderRadius: 100,
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
                      const SizedBox(height: cosmeticFormHeight),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => {
                            if (_formKey.currentState!.validate()) {},
                          },
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
                        children: [
                          Text.rich(
                            TextSpan(
                              text: 'Entrou em ',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: CurrentUserDetails
                                      .getCurrentUserCreationTime(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              CosmeticDialog.showAlertDialog(
                                context: context,
                                dialogTittle: 'Excluir conta?',
                                dialogDescription:
                                    'Tem certeza que deseja excluir sua conta? Todos os seus dados serão excluídos. Esta ação é irreverssível.',
                                onPressed: () => {
                                  CurrentUserDetails.deleteAccount(
                                      context: context),
                                },
                              );
                            },
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
