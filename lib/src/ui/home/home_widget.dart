import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';
import 'package:cosmetic_survey/src/core/entity/user.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/home/home_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import '../../core/firebase/firestore/current_user_details.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  CurrentUserDetails currentUserDetails = CurrentUserDetails();
  Utils utils = Utils();
  var orderDetails = OrderDetails();

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15.0,
                ),
                child: buildUserData(),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: buildOrderData(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder buildUserData() {
    return StreamBuilder<DocumentSnapshot>(
      stream: currentUserDetails.readUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Ocorreu um erro ao carregar registros do Usuário...',
            ),
          );
        } else if (snapshot.hasData) {
          CurrentUser user = CurrentUser(name: '', email: '');

          if (Utils.isFirebaseUser()) {
            User firebaseUser = currentUserDetails.getCurrentUserFromGoogle();

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
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${currentUserDetails.getCurrentTime()}, ${currentUserDetails.handleName(user.name)}!',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        utils.getCurrentDateMonthWeekdayDay(),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 15.0),
            ],
          );
        } else {
          return const CosmeticCircularIndicator();
        }
      },
    );
  }

  FutureBuilder<List<dynamic>> buildOrderData() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait(
        [
          orderDetails.getOrderQuantity(),
          orderDetails.readAllPaymentDetails(),
          orderDetails.getOrdersTotalValue(),
        ],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Ocorreu um erro ao carregar registros do Relatório...',
            ),
          );
        } else if (snapshot.hasData) {
          final orderCount = snapshot.data![0] as int;
          final payments = snapshot.data![1] as List<Payment>;
          final ordersTotalValue = snapshot.data![2] as double;

          var paymentValues = getReportValues(payments);
          var receivedValue = paymentValues[0];
          var valueToReceive = paymentValues[1];

          return Column(
            children: [
              HomeCard(
                value: utils.formatToBrazilianCurrency(ordersTotalValue),
                description: 'Valor total das vendas',
                amountValue: true,
              ),
              HomeCard(
                quantity: orderCount,
                description: 'Pedidos realizados',
                amountValue: false,
              ),
              HomeCard(
                value: utils.formatToBrazilianCurrency(receivedValue),
                description: 'Valor recebido',
                amountValue: true,
              ),
              HomeCard(
                value: utils.formatToBrazilianCurrency(valueToReceive),
                description: 'Valor a receber',
                amountValue: true,
              ),
            ],
          );
        } else {
          return const CosmeticCircularIndicator();
        }
      },
    );
  }

  List<double> getReportValues(List<Payment> payments) {
    var values = <double>[];
    var receivedValue = 0.0;
    var valueToReceive = 0.0;

    for (var payment in payments) {
      if (payment.paymentDate != null) {
        receivedValue += payment.installmentValue!;
      } else {
        valueToReceive += payment.installmentValue!;
      }
    }
    values.add(receivedValue);
    values.add(valueToReceive);

    return values;
  }
}
