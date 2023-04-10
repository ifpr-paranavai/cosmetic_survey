import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_floating_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/ui/customer/cosmetic_customer_dropdown.dart';
import 'package:cosmetic_survey/src/ui/order/payment_order_widget.dart';
import 'package:cosmetic_survey/src/ui/product/cosmetic_product_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

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
  List<Card> cards = [];

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
                  textInputAction: TextInputAction.done,
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
                    itemCount: cards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cards[index];
                    },
                  ),
                ),
                const Divider(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CosmeticElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (cards.isEmpty) {
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
            final GlobalKey<FormState> formKey = GlobalKey<FormState>();
            var quantity = 1;
            var productSelected = Product(
              name: '',
              price: 0.0,
              code: 0,
              brandId: '',
            );
            final valueController = MoneyMaskedTextController(
              initialValue: productSelected.price,
            );

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
                            'Cadastro de Pedido',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'Para inserir um Produto preencha os campos à baixo e clique em "ADICIONAR PRODUTO".',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticProductDropdown(
                            products: widget.products,
                            validator: (value) {
                              if (value == null) {
                                return 'Selecione uma opção!';
                              }
                              return null;
                            },
                            onProductChanged: (value) {
                              productSelected = Product(
                                name: value.name,
                                price: value.price,
                                code: value.code,
                                brandId: value.brandId,
                              );
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
                                productSelected.price = double.parse(value
                                    .toString()
                                    .replaceAll(',', '')
                                    .replaceAll('.', ''));
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticTextFormField(
                            initialValue: quantity.toString(),
                            textInputAction: TextInputAction.done,
                            borderRadius: 10,
                            keyboardType: TextInputType.number,
                            inputText: 'Quantidade',
                            readOnly: false,
                            maxLengh: 5,
                            icon: const Icon(
                              Icons.add_shopping_cart_outlined,
                              color: cosmeticSecondaryColor,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe a Quantidade!';
                              } else {
                                quantity = int.parse(value);
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
                                    setState(
                                      () {
                                        cards.add(
                                          createProductCard(
                                            product: productSelected,
                                            quantity: quantity,
                                          ),
                                        );
                                      },
                                    ),
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CosmeticSnackBar.showSnackBar(
                                        context: context,
                                        message:
                                            'Produto adicionado ao pedido.',
                                      ),
                                    ),
                                  },
                              },
                              buttonName: 'ADICIONAR PRODUTO',
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

  Card createProductCard({required Product product, required int quantity}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
            '${product.code} - ${product.name}\nQuantidade: $quantity\nPreço: ${product.price}'),
        trailing: SizedBox(
          width: 50,
          child: Row(
            children: <Widget>[
              IconButton(
                icon:
                    const Icon(Icons.delete_forever_rounded, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
