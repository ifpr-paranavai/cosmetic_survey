import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:flutter/material.dart';

import '../../components/cosmetic_dialog.dart';
import '../../components/cosmetic_elevated_button.dart';
import '../../components/cosmetic_slidebar.dart';
import '../../components/cosmetic_snackbar.dart';
import '../../components/cosmetic_text_form_field.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../firebase/firestore/product_details.dart';

class ProductActions {
  static Future deleteProduct({
    required BuildContext context,
    required Product product,
  }) {
    return CosmeticDialog.showAlertDialog(
      context: context,
      dialogTittle: 'Excluir Produto',
      dialogDescription: 'Tem certeza que deseja excluir este registro?',
      onPressed: () => {
        FirebaseProductDetails.deleteProductDetails(
          id: product.id,
        ),
        Navigator.pop(context),
        ScaffoldMessenger.of(context).showSnackBar(
          CosmeticSnackBar.showSnackBar(
            context: context,
            message: 'Produto excluído.',
            backgroundColor: Colors.red,
          ),
        ),
      },
    );
  }

  static Future<Widget?> updateProduct({
    required BuildContext context,
    required Product product,
    required GlobalKey<FormState> formKey,
  }) {
    return showModalBottomSheet<Widget>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.only(
          top: 4.0,
          left: cosmeticDefaultSize,
          right: cosmeticDefaultSize,
          bottom: cosmeticDefaultSize,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CosmeticSlideBar(),
                  Text(
                    'Atualizar Produto',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    'Para atualizar as informações preencha os campos à baixo e clique em "ATUALIZAR".',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: product.name,
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.name,
                    inputText: 'Nome',
                    icon: const Icon(
                      Icons.edit,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o Nome!';
                      } else {
                        product.name = value;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: product.value.toString(),
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.number,
                    inputText: 'Valor',
                    icon: const Icon(
                      Icons.attach_money,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o Valor!';
                      } else {
                        product.value = double.parse(value);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: product.quantity.toString(),
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.number,
                    inputText: 'Quantidade',
                    icon: const Icon(
                      Icons.numbers,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a Quantidade!';
                      } else {
                        product.quantity = double.parse(value);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: product.code,
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.number,
                    inputText: 'Código',
                    icon: const Icon(
                      Icons.qr_code_2,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o Código!';
                      } else {
                        product.code = value;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 10),
                  SizedBox(
                    width: double.infinity,
                    child: CosmeticElevatedButton(
                      onPressed: () => {
                        if (formKey.currentState!.validate())
                          {
                            FirebaseProductDetails.updateProductDetails(
                              product: product,
                            ),
                            product.name = '',
                            product.code = '',
                            product.value = 0,
                            product.quantity = 0,
                            Navigator.pop(context),
                            ScaffoldMessenger.of(context).showSnackBar(
                              CosmeticSnackBar.showSnackBar(
                                context: context,
                                message: 'Produto atualizado.',
                              ),
                            ),
                          },
                      },
                      buttonName: 'ATUALIZAR',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
