import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CosmeticSnackBar {
  // Para usar o componente informe o ScaffoldMessenger, passe o contexto e
  // chame a função showSnackBar passando o componente como parâmetro.

  // EXEMPLO DE CHAMADA:
  // ScaffoldMessenger.of(context).showSnackBar(CosmeticSnackBar.showSnackBar(context: context, message: 'Mensagem desejada'));

  static SnackBar showSnackBar({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
  }) {
    return SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor ?? cosmeticPrimaryColor,
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.all(20.0),
    );
  }
}
