import 'package:cosmetic_survey/src/components/cosmetic_floating_button.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/order/order_actions.dart';
import 'package:cosmetic_survey/src/core/order/order_card.dart';
import 'package:cosmetic_survey/src/firebase/firestore/order_details.dart';
import 'package:flutter/material.dart';

import '../../components/cosmetic_circular_indicator.dart';
import '../../constants/colors.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
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
            'Pedidos',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cosmeticSecondaryColor,
              fontSize: 25,
            ),
          ),
        ),
        body: StreamBuilder<List<CosmeticOrder>>(
          stream: OrderDetails.readOrderDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Ocorreu um erro ao listar registros...',
                ),
              );
            } else if (snapshot.hasData) {
              final orders = snapshot.data!;

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  var currentOrder = orders[index];

                  CosmeticOrder order = CosmeticOrder(
                    id: currentOrder.id,
                    products: currentOrder.products,
                    customer: currentOrder.customer,
                    totalValue: currentOrder.totalValue,
                    cicle: currentOrder.cicle,
                  );

                  return OrderCard(
                    order: order,
                    onPressedDelete: () => OrderActions.deleteOrder(
                      context: context,
                      orderId: order.id,
                    ),
                  );
                },
              );
            } else {
              return const CosmeticCircularIndicator();
            }
          },
        ),
        floatingActionButton: CosmeticFloatingActionButton(
          onPressed: () => {
            //TODO tela para cadastrar um pedido
          },
          icon: Icons.add,
        ),
      ),
    );
  }
}
