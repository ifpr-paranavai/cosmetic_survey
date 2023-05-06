import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/order/payment_card.dart';
import 'package:flutter/material.dart';

class InstallmentsWidget extends StatefulWidget {
  CosmeticOrder order;

  InstallmentsWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<InstallmentsWidget> createState() => _InstallmentsWidgetState();
}

class _InstallmentsWidgetState extends State<InstallmentsWidget> {
  var orderDetails = OrderDetails();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: buildPaymentData(),
      ),
    );
  }

  AppBar buildAppBar() {
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
        'Pagamento',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cosmeticSecondaryColor,
          fontSize: 25,
        ),
      ),
    );
  }

  FutureBuilder<List<dynamic>> buildPaymentData() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        orderDetails.readPaymentDetailsByOrderId(widget.order.id),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Ocorreu um erro ao carregar registros de Pagamentos...',
            ),
          );
        } else if (snapshot.hasData) {
          final payments = snapshot.data![0] as List<Payment>;

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              var payment = payments[index];

              return PaymentCard(order: widget.order, payment: payment);
            },
          );
        } else {
          return const CosmeticCircularIndicator();
        }
      },
    );
  }
}
