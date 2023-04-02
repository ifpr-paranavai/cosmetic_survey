import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/ui/customer/cosmetic_customer_dropdown.dart';
import 'package:cosmetic_survey/src/ui/product/cosmetic_product_dropdown.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/entity/customer.dart';

class CreateOrderWidget extends StatefulWidget {
  List<Customer> customers;
  List<Product> products;

  CreateOrderWidget({
    Key? key,
    required this.customers,
    required this.products,
  }) : super(key: key);

  @override
  State<CreateOrderWidget> createState() => _CreateOrderWidgetState();
}

class _CreateOrderWidgetState extends State<CreateOrderWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _cicleController = TextEditingController();
  final _commentsController = TextEditingController();
  final _customerDropdownController = TextEditingController();

  OrderDetails orderDetails = OrderDetails();
  Utils utils = Utils();

  var cicle = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {
              Navigator.pop(context),
            },
            icon: const Icon(Icons.arrow_back_outlined),
            color: cosmeticSecondaryColor,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Cadastrar Pedido',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cosmeticSecondaryColor,
              fontSize: 25,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(cosmeticDefaultSize),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Data atual: ${utils.getCurrentDateYearNumMonthDay()}',
                        ),
                      ],
                    ),
                    const SizedBox(height: cosmeticFormHeight - 20),
                    CosmeticCustomerDropdown(
                      customers: widget.customers,
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione uma opção!';
                        }
                        return null;
                      },
                      onCustomerChanged: (value) {
                        _customerDropdownController.text = value.id;
                      },
                    ),
                    const SizedBox(height: cosmeticFormHeight - 20),
                    CosmeticTextFormField(
                      controller: _cicleController,
                      textInputAction: TextInputAction.next,
                      borderRadius: 10,
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      inputText: 'Ciclo',
                      icon: const Icon(
                        Icons.menu_open_outlined,
                        color: cosmeticSecondaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o Ciclo do Pedido!';
                        } else {
                          cicle = int.parse(value);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: cosmeticFormHeight - 20),
                    CosmeticTextFormField(
                      controller: _commentsController,
                      textInputAction: TextInputAction.next,
                      borderRadius: 10,
                      keyboardType: TextInputType.text,
                      readOnly: false,
                      inputText: 'Observações',
                      icon: const Icon(
                        Icons.comment_outlined,
                        color: cosmeticSecondaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _commentsController.text = '';
                        }
                        return null;
                      },
                    ),
                    const Divider(height: 60),
                    CosmeticProductDropdown(
                      products: widget.products,
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione uma opção!';
                        }
                        return null;
                      },
                      onProductChanged: (value) {
                        //TODO decidir como vai ser salvo esse valor no banco
                      },
                    ),
                    const SizedBox(height: cosmeticFormHeight - 10),
                    SizedBox(
                      width: double.infinity,
                      child: CosmeticElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            orderDetails.addOrderDetails(
                              order: CosmeticOrder(
                                // products: [],
                                customerId: _customerDropdownController.text,
                                cicle: cicle,
                                comments: _commentsController.text,
                              ),
                            );
                            _cicleController.clear();
                            _commentsController.clear();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              CosmeticSnackBar.showSnackBar(
                                context: context,
                                message: 'Pedido criado.',
                              ),
                            );
                          }
                        },
                        buttonName: 'IR PARA PAGAMENTOS',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
