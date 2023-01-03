import 'package:fluttertoast/fluttertoast.dart';

class FirebaseExceptions {
  static Future<bool?> catchFirebaseException(String e) async {
    if (e == 'user-not-found' || e == 'wrong-password') {
      return Fluttertoast.showToast(
        msg: 'E-Mail ou Senha incorretos.',
        gravity: ToastGravity.BOTTOM,
      );
    } else if (e == 'too-many-requests') {
      return Fluttertoast.showToast(
        msg:
            'Você tentou fazer login muitas vezes seguidas. Aguarde um instante e tente novamente.',
        gravity: ToastGravity.BOTTOM,
      );
    } else if (e == 'weak-password') {
      return Fluttertoast.showToast(
        msg: 'A senha deve conter ao menos 6 caracteres.',
        gravity: ToastGravity.BOTTOM,
      );
    } else if (e == 'email-already-in-use') {
      return Fluttertoast.showToast(
        msg: 'Este E-Mail já existe.',
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      return Fluttertoast.showToast(
        msg: 'Erro desconhecido, contate o suporte. Código do erro: $e',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
