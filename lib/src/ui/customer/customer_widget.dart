import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/masks.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/customer_details.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_floating_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_mask_form_field.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/ui/customer/customer_card.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'customer_actions.dart';

class CustomerWidget extends StatefulWidget {
  const CustomerWidget({Key? key}) : super(key: key);

  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

var suggestions = <Customer>[];
var aux = <Customer>[];

class _CustomerWidgetState extends State<CustomerWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cellNumberController = TextEditingController();

  CustomerDetails customerDetails = CustomerDetails();

  @override
  Widget build(BuildContext pageContext) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: StreamBuilder<List<Customer>>(
          stream: customerDetails.readCustomerDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Ocorreu um erro ao listar registros...',
                ),
              );
            } else if (snapshot.hasData) {
              final customers = snapshot.data!;
              aux.clear();

              if (customers.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum registro encontrado!',
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    var currentCustomer = customers[index];

                    Customer customer = Customer(
                      id: currentCustomer.id,
                      name: currentCustomer.name,
                      cpf: currentCustomer.cpf,
                      cellNumber: currentCustomer.cellNumber,
                      creationTime: currentCustomer.creationTime,
                    );

                    aux.add(customer);

                    return CustomerCard(
                      customer: customer,
                      onPressedDelete: () {
                        HapticFeedback.vibrate();

                        CustomerActions.deleteCustomer(
                          context: context,
                          customer: customer,
                        );
                      },
                    );
                  },
                );
              }
            } else {
              return const CosmeticCircularIndicator();
            }
          },
        ),
        floatingActionButton: CosmeticFloatingActionButton(
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
                            'Cadastro de Cliente',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'Para realizar o cadastro preencha os campos abaixo e clique em "SALVAR".',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticTextFormField(
                            controller: _nameController,
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
                                _nameController.text = value;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticMaskFormField(
                            controller: _cpfController,
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
                              if (value != null && value.isNotEmpty) {
                                if (CPFValidator.isValid(value)) {
                                  _cpfController.text = value;
                                } else {
                                  return 'CPF inválido!';
                                }
                              } else {
                                _cpfController.text = '';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticMaskFormField(
                            controller: _cellNumberController,
                            textInputAction: TextInputAction.done,
                            borderRadius: 10,
                            keyboardType: TextInputType.number,
                            maskTextInputFormatter:
                                CosmeticMasks.MASK_CELL_NUMBER,
                            inputText: 'Número de Telefone',
                            icon: const Icon(
                              Icons.phone_outlined,
                              color: cosmeticSecondaryColor,
                            ),
                            validator: (value) {
                              if (!value.isEmpty &&
                                  value.toString().length != 16) {
                                return 'Número inválido, use o formato (99) 9 9999-9999';
                              }

                              if (value.toString().length == 16) {
                                _cellNumberController.text = value;
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
                                    customerDetails.addCustomerDetails(
                                      cCustomer: Customer(
                                        name: _nameController.text,
                                        cpf: _cpfController.text,
                                        cellNumber: _cellNumberController.text,
                                      ),
                                    ),
                                    _nameController.clear(),
                                    _cpfController.clear(),
                                    _cellNumberController.clear(),
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CosmeticSnackBar.showSnackBar(
                                        context: context,
                                        message: 'Cliente criado.',
                                      ),
                                    ),
                                  },
                              },
                              buttonName: 'SALVAR',
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
          icon: Icons.add,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Clientes',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cosmeticSecondaryColor,
          fontSize: 25,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            suggestions.addAll(aux);

            showSearch(
              context: context,
              delegate: CosmeticSearchDelegate(),
            );
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
      ],
    );
  }
}

class CosmeticSearchDelegate extends SearchDelegate {
  var searchResults = suggestions;

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          suggestions.clear();

          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              suggestions.clear();

              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
      ];

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text(
          'Ops... Parece que algo inesperado aconteceu.\nTente novamente...'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.name.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        Customer customer = Customer(
          id: suggestion.id,
          name: suggestion.name,
          cpf: suggestion.cpf,
          cellNumber: suggestion.cellNumber,
          creationTime: suggestion.creationTime,
        );

        return CustomerCard(
          customer: customer,
          onPressedDelete: () {
            HapticFeedback.vibrate();

            CustomerActions.deleteCustomer(
              context: context,
              customer: customer,
            );
          },
        );
      },
    );
  }
}
