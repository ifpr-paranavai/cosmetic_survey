import 'dart:math';

import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/masks.dart';
import '../constants/sizes.dart';
import '../firebase/firestore/customer_details.dart';
import 'cosmetic_cpf_form_field.dart';
import 'cosmetic_elevated_button.dart';
import 'cosmetic_slidebar.dart';
import 'cosmetic_snackbar.dart';
import 'cosmetic_text_form_field.dart';

class CosmeticCard extends StatelessWidget {
  Customer customer;

  CosmeticCard({Key? key, required this.customer}) : super(key: key);

  final _random = Random();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.primaries[_random.nextInt(Colors.primaries.length)]
                  [_random.nextInt(9) * 100],
          child: Text(
            customer.name.toString().substring(0, 1).toUpperCase(),
          ),
        ),
        title: Text(customer.name),
        subtitle: Text(customer.cpfCnpj),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showModalBottomSheet(
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
                        key: _formKey,
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
                                  maskTextInputFormatter:
                                      CosmeticMasks.MASK_CPF,
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
                                      if (_formKey.currentState!.validate())
                                        {
                                          FirebaseCustomerDetails
                                              .updateCustomerDetails(
                                            id: customer.id,
                                            name: customer.name,
                                            cpfCnpj: customer.cpfCnpj,
                                          ),
                                          customer.name = '',
                                          customer.cpfCnpj = '',
                                          Navigator.pop(context),
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                },
              ),
              IconButton(
                icon:
                    const Icon(Icons.delete_forever_rounded, color: Colors.red),
                onPressed: () {
                  FirebaseCustomerDetails.deleteCustomerDetails(
                    id: customer.id,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    CosmeticSnackBar.showSnackBar(
                      context: context,
                      message: 'Cliente excluído.',
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
