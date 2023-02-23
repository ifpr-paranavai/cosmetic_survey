
import 'package:cosmetic_survey/src/core/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:flutter/material.dart';

class OrderActions {
  static Future deleteOrder({
    required BuildContext context,
    required dynamic orderId,
  }) {
    return CosmeticDialog.showAlertDialog(
      context: context,
      dialogTittle: 'Excluir Pedido',
      dialogDescription: 'Tem certeza que deseja excluir este registro?',
      onPressed: () => {
        OrderDetails.deleteOrderDetails(
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
