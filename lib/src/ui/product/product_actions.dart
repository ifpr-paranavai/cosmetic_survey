import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/brand_details.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/product_details.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../core/entity/brand.dart';
import '../../core/utils/utils.dart';

class ProductActions {
  static Future deleteProduct({
    required BuildContext context,
    required Product product,
  }) {
    ProductDetails productDetails = ProductDetails();

    return CosmeticDialog.showAlertDialog(
      context: context,
      dialogTittle: 'Excluir Produto',
      dialogDescription: 'Tem certeza que deseja excluir este registro?',
      onPressed: () => {
        productDetails.deleteProductDetails(
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
    required List<Brand> brands,
  }) {
    var productDetails = ProductDetails();
    var brandDetails = BrandDetails();
    var utils = Utils();

    final valueController =
        MoneyMaskedTextController(initialValue: product.price);

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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Para atualizar as informações preencha os campos à baixo e clique em "ATUALIZAR".',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: product.name,
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    maxLengh: 55,
                    inputText: 'Nome',
                    readOnly: false,
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
                    controller: valueController,
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.number,
                    inputText: 'Valor',
                    readOnly: false,
                    icon: const Icon(
                      Icons.attach_money,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o Valor!';
                      } else {
                        product.price = utils.formatStringValue(value);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: product.code.toString(),
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.number,
                    inputText: 'Código',
                    readOnly: false,
                    icon: const Icon(
                      Icons.qr_code_2,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o Código!';
                      } else {
                        product.code = int.parse(value);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    //TODO fazer essa busca de outra forma
                    initialValue: brandDetails.getBrandName(
                      brands: brands,
                      brandId: product.brandId,
                    ),
                    textInputAction: TextInputAction.done,
                    borderRadius: 10,
                    keyboardType: TextInputType.number,
                    inputText: 'Marca',
                    readOnly: true,
                    icon: const Icon(
                      Icons.space_dashboard_rounded,
                      color: cosmeticSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: cosmeticFormHeight - 10),
                  SizedBox(
                    width: double.infinity,
                    child: CosmeticElevatedButton(
                      onPressed: () => {
                        if (formKey.currentState!.validate())
                          {
                            productDetails.updateProductDetails(
                              product: product,
                            ),
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

  static Future showInfoDialog(
      {required BuildContext context,
      required Product product,
      required String brand}) {
    var utils = Utils();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informações detalhadas'),
        content: Text(
            'Nome: ${product.name}\nPreço: R\$ ${utils.formatToBrazilianCurrency(product.price)}\nCódigo: ${product.code}\nMarca: $brand\nData de criação: ${Utils.formatDate(date: product.creationTime!)}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              overlayColor: MaterialStatePropertyAll<Color>(
                cosmeticPrimaryColor.withOpacity(0.1),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                color: cosmeticPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
