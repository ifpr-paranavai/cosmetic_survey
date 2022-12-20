import 'package:cosmetic_survey/src/constants/masks.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

import '../../components/cosmetic_cpf_form_field.dart';
import '../../components/cosmetic_elevated_button.dart';
import '../../components/cosmetic_floating_button.dart';
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
        floatingActionButton: CosmeticFloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey,
                          ),
                          margin: const EdgeInsets.all(8.0),
                          height: 5.0,
                          width: 100.0,
                        ),
                      ),
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
                            if (_formKey.currentState!.validate()) {},
                          },
                          buttonName: 'SALVAR',
                        ),
                      )
                    ],
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
