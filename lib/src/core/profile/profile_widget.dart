import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/constants/colors.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/core/profile/update_profile_widget.dart';
import 'package:cosmetic_survey/src/firebase/firestore/current_user_details.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../components/cosmetic_circular_indicator.dart';
import '../../components/cosmetic_dialog.dart';
import '../../components/cosmetic_profile_menu_widget.dart';
import '../../constants/image_path.dart';
import '../../constants/sizes.dart';
import '../../firebase/auth/firebase_auth.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Perfil',
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
            child: StreamBuilder<DocumentSnapshot>(
              stream: CurrentUserDetails.readUserData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Ocorreu um erro ao carregar registros...',
                    ),
                  );
                } else if (snapshot.hasData) {
                  User user = User(
                    id: snapshot.data!['id'],
                    name: snapshot.data!['name'],
                    email: snapshot.data!['email'],
                  );

                  return Column(
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
                                LineAwesomeIcons.alternate_pencil,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProfileWidget(
                                  user: user,
                                ),
                              ),
                            )
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cosmeticPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Editar Perfil',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      CosmeticProfileMenuWidget(
                        title: 'Configurações',
                        icon: LineAwesomeIcons.cog,
                        onPress: () {},
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      CosmeticProfileMenuWidget(
                        title: 'Sobre o aplicativo',
                        icon: LineAwesomeIcons.info,
                        onPress: () {},
                      ),
                      CosmeticProfileMenuWidget(
                        title: 'Sair',
                        icon: LineAwesomeIcons.alternate_sign_out,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          CosmeticDialog.showAlertDialog(
                            context: context,
                            dialogTittle: 'Sair do Aplicativo?',
                            dialogDescription:
                                'Tem certeza que deseja realmente sair?',
                            onPressed: () => {
                              FirebaseAuthentication.signOut(context: context),
                            },
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return const CosmeticCircularIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
