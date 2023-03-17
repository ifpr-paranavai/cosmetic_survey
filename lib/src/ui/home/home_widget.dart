import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/home/home_card.dart';
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
                      //TODO fazer com que o texto fique na esquerda
                      Text(
                        '${currentUserDetails.getTimeDay()}, ${currentUserDetails.handleName(user.name)}!',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.left,
                      ),
                      HomeCard(
                        value: 500.00,
                        description: 'Valor total das vendas',
                        amountValue: true,
                      ),
                      HomeCard(
                        quantity: 15,
                        description: 'Pedidos realizados',
                        amountValue: false,
                      ),
                      HomeCard(
                        value: 300.00,
                        description: 'Valor recebido',
                        amountValue: true,
                      ),
                      HomeCard(
                        value: 200.00,
                        description: 'Valor a receber',
                        amountValue: true,
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
