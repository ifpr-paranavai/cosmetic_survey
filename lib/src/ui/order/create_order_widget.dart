import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_floating_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/ui/customer/cosmetic_customer_dropdown.dart';
import 'package:cosmetic_survey/src/ui/order/payment_order_widget.dart';
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
  List<Widget> dropdowns = [];

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
                      return 'Informe o ciclo do pedido!';
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
                const Divider(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: dropdowns.length,
                    itemBuilder: (BuildContext context, int index) {
                      return dropdowns[index];
                    },
                  ),
                ),
                const Divider(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CosmeticElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (dropdowns.isEmpty) {
                          CosmeticDialog.showAlertDialog(
                            context: context,
                            dialogTittle: 'Informação!',
                            dialogDescription:
                                'O pedido deve conter ao menos um produto!',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            showCancelButton: false,
                          );
                        } else {
                          var order = CosmeticOrder(
                            // products: [],
                            customerId: _customerDropdownController.text,
                            cicle: cicle,
                            comments: _commentsController.text,
                            installments: 0,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentOrderWidget(order: order),
                            ),
                          );
                        }
                      }
                    },
                    buttonName: 'IR PARA PAGAMENTOS',
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: CosmeticFloatingActionButton(
          onPressed: () {
            setState(
              () {
                dropdowns.add(
                  Column(
                    children: [
                      const SizedBox(height: cosmeticFormHeight - 20),
                      createDropdownItem(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Quantidade: '),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.minimize_outlined),
                          ),
                          const SizedBox(width: 12.0),
                          const Text('0'),
                          const SizedBox(width: 12.0),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: Icons.add,
        ),
      ),
    );
  }

  CosmeticProductDropdown createDropdownItem() {
    return CosmeticProductDropdown(
      products: widget.products,
      validator: (value) {
        if (value == null) {
          return 'Selecione uma opção!';
        }
        return null;
      },
      onProductChanged: (value) {
        //TODO
      },
    );
  }
}
