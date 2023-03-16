import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/firebase/firestore/current_user_details.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  CurrentUserDetails currentUserDetails = CurrentUserDetails();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15.0),
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

                  if (Utils.isFirebaseUser()) {
                    User firebaseUser =
                        currentUserDetails.getCurrentUserFromGoogle();

                    user = CurrentUser(
                      id: firebaseUser.uid,
                      name: firebaseUser.displayName!,
                      email: firebaseUser.email!,
                    );
                  } else if (!Utils.isFirebaseUser()) {
                    user = CurrentUser(
                      id: snapshot.data!['id'],
                      name: snapshot.data!['name'],
                      email: snapshot.data!['email'],
                    );
                  }

                  return Column(
                    children: [
                      Text(
                        '${currentUserDetails.getTimeDay()}, ${currentUserDetails.handleName(user.name)}!',
                        style: Theme.of(context).textTheme.titleLarge,
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
