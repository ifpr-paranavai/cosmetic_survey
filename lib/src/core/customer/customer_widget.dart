import 'package:cosmetic_survey/src/components/cosmetic_card.dart';
import 'package:cosmetic_survey/src/constants/masks.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/firebase/firestore/customer_details.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

import '../../components/cosmetic_circular_indicator.dart';
import '../../components/cosmetic_cpf_form_field.dart';
import '../../components/cosmetic_elevated_button.dart';
import '../../components/cosmetic_floating_button.dart';
import '../../components/cosmetic_slidebar.dart';
import '../../components/cosmetic_text_form_field.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class CustomerWidget extends StatefulWidget {
  const CustomerWidget({Key? key}) : super(key: key);

  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<CustomerWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();

  String name = '';
  String cpf = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
        ),
        body: StreamBuilder<List<Customer>>(
          stream: FirebaseCustomerDetails.readCustomerDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Ocorreu um erro ao listar registros...',
                ),
              );
            } else if (snapshot.hasData) {
              final customers = snapshot.data!;

              return ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  var currentCustomer = customers[index];

                  return CosmeticCard(
                    customer: Customer(
                      id: currentCustomer.id,
                      name: currentCustomer.name,
                      cpfCnpj: currentCustomer.cpfCnpj,
                    ),
                  );
                },
              );
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
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            'Para realizar o cadastro preencha os campos à baixo e clique em "Salvar".',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticTextFormField(
                            controller: _nameController,
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
                                name = value;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticCpfFormField(
                            controller: _cpfController,
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
                                cpf = value;
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
                                    FirebaseCustomerDetails.addCustomerDetails(
                                      name: _nameController.text,
                                      cpfCnpj: _cpfController.text,
                                    ),
                                    _nameController.clear(),
                                    _cpfController.clear(),
                                    Navigator.pop(context),
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
}
