import 'package:cosmetic_survey/src/core/components/cosmetic_cpf_form_field.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/core/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/masks.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/customer_details.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

class CustomerActions {
  static Future deleteCustomer({
    required BuildContext context,
    required Customer customer,
  }) {
    return CosmeticDialog.showAlertDialog(
      context: context,
      dialogTittle: 'Excluir Cliente',
      dialogDescription: 'Tem certeza que deseja excluir este registro?',
      onPressed: () => {
        CustomerDetails.deleteCustomerDetails(
          id: customer.id,
        ),
        Navigator.pop(context),
        ScaffoldMessenger.of(context).showSnackBar(
          CosmeticSnackBar.showSnackBar(
            context: context,
            message: 'Cliente excluído.',
            backgroundColor: Colors.red,
          ),
        ),
      },
    );
  }

  static Future<Widget?> updateCustomer({
    required BuildContext context,
    required Customer customer,
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
                    'Atualizar Cliente',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    'Para atualizar as informações preencha os campos à baixo e clique em "ATUALIZAR".',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: customer.name,
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.name,
                    inputText: 'Nome',
                    icon: const Icon(
                      Icons.person_outline_rounded,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o Nome!';
                      } else {
                        customer.name = value;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticCpfFormField(
                    initialValue: customer.cpfCnpj,
                    textInputAction: TextInputAction.done,
                    borderRadius: 10,
                    keyboardType: TextInputType.number,
                    maskTextInputFormatter: CosmeticMasks.MASK_CPF,
                    inputText: 'CPF',
                    icon: const Icon(
                      Icons.document_scanner_outlined,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o CPF!';
                      }
                      if (CPFValidator.isValid(value)) {
                        customer.cpfCnpj = value;
                      } else {
                        return 'CPF inválido!';
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
                            CustomerDetails.updateCustomerDetails(
                              id: customer.id,
                              name: customer.name,
                              cpfCnpj: customer.cpfCnpj,
                            ),
                            customer.name = '',
                            customer.cpfCnpj = '',
                            Navigator.pop(context),
                            ScaffoldMessenger.of(context).showSnackBar(
                              CosmeticSnackBar.showSnackBar(
                                context: context,
                                message: 'Cliente atualizado.',
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
