import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/masks.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/customer_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_mask_form_field.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerActions {
  static Future deleteCustomer({
    required BuildContext context,
    required Customer customer,
  }) {
    CustomerDetails customerDetails = CustomerDetails();

    return CosmeticDialog.showAlertDialog(
      context: context,
      dialogTittle: 'Excluir Cliente',
      dialogDescription: 'Tem certeza que deseja excluir este registro?',
      onPressed: () => {
        customerDetails.deleteCustomerDetails(
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
    CustomerDetails customerDetails = CustomerDetails();

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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Para atualizar as informações preencha os campos abaixo e clique em "ATUALIZAR".',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: customer.name,
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.name,
                    inputText: 'Nome',
                    readOnly: false,
                    maxLengh: 55,
                    textCapitalization: TextCapitalization.words,
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
                  CosmeticMaskFormField(
                    initialValue: customer.cpf,
                    textInputAction: TextInputAction.next,
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
                        customer.cpf = value;
                      } else {
                        return 'CPF inválido!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticMaskFormField(
                    initialValue: customer.cellNumber,
                    textInputAction: TextInputAction.done,
                    borderRadius: 10,
                    keyboardType: TextInputType.number,
                    maskTextInputFormatter: CosmeticMasks.MASK_CELL_NUMBER,
                    inputText: 'Número de Telefone',
                    icon: const Icon(
                      Icons.phone_outlined,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (!value.isEmpty && value.toString().length != 16) {
                        return 'Número inválido, use o formato (99) 9 9999-9999';
                      }

                      if (value.toString().length == 16) {
                        customer.cellNumber = value;
                      }

                      if (value.toString().isEmpty) {
                        customer.cellNumber = '';
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
                            customerDetails.updateCustomerDetails(
                              cCustomer: Customer(
                                id: customer.id,
                                name: customer.name,
                                cpf: customer.cpf,
                                cellNumber: customer.cellNumber,
                                creationTime: customer.creationTime,
                              ),
                            ),
                            customer.name = '',
                            customer.cpf = '',
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

  static Future showInfoDialog(
      {required BuildContext context, required Customer customer}) {
    var cellNumber =
        customer.cellNumber != '' ? customer.cellNumber : 'Não informado.';
    bool cellNumberInformed = customer.cellNumber != '';

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informações detalhadas'),
        content: Text(
            'Nome: ${customer.name}\nCPF: ${customer.cpf}\nTelefone: $cellNumber\nData de criação: ${Utils.formatDate(date: customer.creationTime!)}'),
        actions: <Widget>[
          cellNumberInformed
              ? sendWhatsAppMessage(phoneNumber: cellNumber!)
              : const SizedBox(),
          cellNumberInformed
              ? makeCall(phoneNumber: cellNumber!)
              : const SizedBox(),
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

  static IconButton makeCall({required String phoneNumber}) {
    return IconButton(
      onPressed: () {
        launchUrl(
          Uri(
            scheme: 'tel',
            path: phoneNumber,
          ),
        );
      },
      icon: const Icon(
        Icons.call,
        color: Colors.green,
      ),
    );
  }

  static IconButton sendWhatsAppMessage({required String phoneNumber}) {
    return IconButton(
      onPressed: () {
        launchUrl(
          Uri.parse(
            "whatsapp://send?phone=$phoneNumber&text=",
          ),
        );
      },
      icon: const Icon(
        FontAwesomeIcons.whatsapp,
        color: cosmeticWhatsAppColor,
      ),
    );
  }
}
