import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildPaymentData(),
          const Divider(height: 60),
          buildFooterButton(context),
        ],
      ),
    );
  }

  SizedBox buildFooterButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: CosmeticElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);

          orderDetails.updateOrderDetails(widget.order);
        },
        buttonName: 'FECHAR E SALVAR',
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
        'Pagamentos',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cosmeticSecondaryColor,
          fontSize: 25,
        ),
      ),
    );
  }

  FutureBuilder buildPaymentData() {
    return FutureBuilder(
      future: orderDetails.readPaymentDetailsByOrderId(widget.order.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Ocorreu um erro ao carregar registros de Pagamentos...',
            ),
          );
        } else if (snapshot.hasData) {
          final payments = snapshot.data!;

          return SizedBox(
            height: MediaQuery.of(context).size.width * 1.6,
            child: ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                var currentPayment = payments[index];

                var payment = Payment(
                  id: currentPayment.id,
                  orderId: currentPayment.orderId,
                  installmentValue: currentPayment.installmentValue,
                  paymentDate: currentPayment.paymentDate,
                  installmentNumber: currentPayment.installmentNumber,
                  paymentType: currentPayment.paymentType,
                );

                return PaymentCard(order: widget.order, payment: payment);
              },
            ),
          );
        } else {
          return const CosmeticCircularIndicator();
        }
      },
    );
  }
}
