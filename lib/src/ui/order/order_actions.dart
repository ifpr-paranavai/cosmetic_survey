import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:flutter/material.dart';

class OrderActions {
  static Future deleteOrder({
    required BuildContext context,
    required dynamic orderId,
  }) {
    OrderDetails orderDetails = OrderDetails();

    return CosmeticDialog.showAlertDialog(
      context: context,
      dialogTittle: 'Excluir Pedido',
      dialogDescription: 'Tem certeza que deseja excluir este registro?',
      onPressed: () => {
        orderDetails.deleteOrderDetails(
          id: orderId,
        ),
        Navigator.pop(context),
        ScaffoldMessenger.of(context).showSnackBar(
          CosmeticSnackBar.showSnackBar(
            context: context,
            message: 'Pedido excluído.',
            backgroundColor: Colors.red,
          ),
        ),
      },
    );
  }
}
