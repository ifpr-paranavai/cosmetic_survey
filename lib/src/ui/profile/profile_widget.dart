import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/firebase_providers.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/core/firebase/auth/firebase_auth.dart';
import 'package:cosmetic_survey/src/core/firebase/auth/google_auth.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/current_user_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/about/about.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_profile_menu_widget.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/ui/profile/profile_actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({Key? key}) : super(key: key);
  CurrentUserDetails currentUserDetails = CurrentUserDetails();
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();

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
              stream: currentUserDetails.readUserData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Ocorreu um erro ao carregar registros...',
                    ),
                  );
                } else if (snapshot.hasData) {
                  CurrentUser user = CurrentUser(name: '', email: '');
                  SizedBox sizedBox = const SizedBox();
                  GestureDetector gestureDetector = GestureDetector();

                  if (Utils.isFirebaseUser()) {
                    User firebaseUser =
                        currentUserDetails.getCurrentUserFromGoogle();

                    user = CurrentUser(
                      id: firebaseUser.uid,
                      name: firebaseUser.displayName!,
                      email: firebaseUser.email!,
                      imagePath: firebaseUser.photoURL!,
                    );

                    sizedBox = googleUserSizedBox(user);
                    gestureDetector = GestureDetector(
                      child: const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                    );
                  } else if (!Utils.isFirebaseUser()) {
                    user = CurrentUser(
                      id: snapshot.data!['id'],
                      name: snapshot.data!['name'],
                      email: snapshot.data!['email'],
                      imagePath: snapshot.data!['imagePath'],
                    );

                    sizedBox = emailUserSizedBox(user);
                    gestureDetector =
                        gestureDetectorEmailUser(context: context, user: user);
                  }

                  return Column(
                    children: [
                      Stack(
                        children: [
                          sizedBox,
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: gestureDetector,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      // SizedBox(
                      //   width: 200,
                      //   child: ElevatedButton(
                      //     onPressed: () => {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => UpdateProfileWidget(
                      //             user: user,
                      //           ),
                      //         ),
                      //       )
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: cosmeticPrimaryColor,
                      //       side: BorderSide.none,
                      //       shape: const StadiumBorder(),
                      //     ),
                      //     child: const Text(
                      //       'Editar Perfil',
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 30),
                      // const Divider(),
                      // CosmeticProfileMenuWidget(
                      //   title: 'Configurações',
                      //   icon: LineAwesomeIcons.cog,
                      //   onPress: () {},
                      // ),
                      const Divider(),
                      const SizedBox(height: 10),
                      CosmeticProfileMenuWidget(
                        title: 'Sobre o aplicativo',
                        icon: LineAwesomeIcons.info,
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutWidget(),
                            ),
                          );
                        },
                      ),
                      CosmeticProfileMenuWidget(
                        title: 'Sair',
                        icon: LineAwesomeIcons.alternate_sign_out,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          HapticFeedback.vibrate();

                          CosmeticDialog.showAlertDialog(
                            context: context,
                            dialogTittle: 'Sair do Aplicativo?',
                            dialogDescription:
                                'Tem certeza que deseja realmente sair?',
                            onPressed: () => {
                              if (currentUserDetails.getCurrentUserProvider() ==
                                  FirebaseProvider.GOOGLE)
                                {
                                  googleSignInProvider.googleLogout(
                                      context: context),
                                }
                              else if (currentUserDetails
                                      .getCurrentUserProvider() ==
                                  FirebaseProvider.EMAIL)
                                {
                                  firebaseAuthentication.signOut(
                                      context: context),
                                }
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

  Widget modalBottomSheetContent(
      {required BuildContext context, required CurrentUser user}) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4.0,
        left: cosmeticDefaultSize,
        right: cosmeticDefaultSize,
        bottom: cosmeticDefaultSize,
      ),
      child: Form(
        // key: formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CosmeticSlideBar(),
                const SizedBox(height: 5.0),
                GestureDetector(
                  onTap: () async => {
                    if (await Utils.askPermissionCamera())
                      {
                        ProfileActions.pickCameraImage(
                          context: context,
                          user: user,
                        ),
                      },
                    handlePermissionCamera(),
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.camera),
                      const SizedBox(width: 10.0),
                      Text(
                        'Câmera',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(),
                const SizedBox(height: 5.0),
                GestureDetector(
                  onTap: () async => {
                    if (await Utils.askPermissionStorage())
                      {
                        ProfileActions.pickGalleryImage(
                          context: context,
                          user: user,
                        ),
                      },
                    handlePermissionStorage(),
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.image),
                      const SizedBox(width: 10.0),
                      Text(
                        'Galeria',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handlePermissionCamera() async {
    if (await Utils.isPermissionCameraDenied()) {
      Fluttertoast.showToast(
        msg:
            'A permissão foi negada! Acesse as configurações do dispositivo e permita que o aplicativo Cosmetic Survey acesse a Câmera.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  handlePermissionStorage() async {
    if (await Utils.isPermissionCameraDenied()) {
      Fluttertoast.showToast(
        msg:
            'A permissão foi negada! Acesse as configurações do dispositivo e permita que o aplicativo Cosmetic Survey acesse Arquivos e mídia.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  GestureDetector gestureDetectorEmailUser(
      {required BuildContext context, required CurrentUser user}) {
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet(
          context: context,
          builder: (context) => modalBottomSheetContent(
            context: context,
            user: user,
          ),
        )
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cosmeticPrimaryColor,
          border: Border.all(width: 1.5, color: Colors.white),
        ),
        child: const Icon(
          LineAwesomeIcons.alternate_pencil,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  SizedBox emailUserSizedBox(CurrentUser user) {
    return SizedBox(
      height: 100,
      width: 100,
      child: ClipOval(
        child: Image(
          image: NetworkImage(
            user.imagePath != ''
                ? user.imagePath!
                : 'https://i.pinimg.com/564x/cb/b1/ef/cbb1ef1ee0bf43d633393d7203a4d497.jpg',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  SizedBox googleUserSizedBox(CurrentUser user) {
    return SizedBox(
      child: ClipOval(
        child: Image(
          image: NetworkImage(user.imagePath!),
        ),
      ),
    );
  }
}
