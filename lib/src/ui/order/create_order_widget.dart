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
import 'package:decimal/decimal.dart';
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
  List<Product> selectedProdutcs = [];
  var orderTotalValue = Decimal.zero;

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
                  textInputAction: TextInputAction.done,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Produtos: ',
                          ),
                          TextSpan(
                            text: '${selectedProdutcs.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: ' | Valor total: ',
                          ),
                          TextSpan(
                            text:
                                'R\$ ${utils.formatToBrazilianCurrency(orderTotalValue.toDouble())}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                buildSelectedProductsListView(),
                const Divider(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CosmeticElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (selectedProdutcs.isEmpty) {
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
                            products: selectedProdutcs,
                            customerId: _customerDropdownController.text,
                            cicle: cicle,
                            comments: _commentsController.text,
                            installments: 0,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentOrderWidget(
                                order: order,
                                totalValue: utils.formatToBrazilianCurrency(
                                  orderTotalValue.toDouble(),
                                ),
                              ),
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
        floatingActionButton: buildCosmeticFloatingActionButton(context),
      ),
    );
  }

  Expanded buildSelectedProductsListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: selectedProdutcs.length,
        itemBuilder: (BuildContext context, int index) {
          var product = selectedProdutcs[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                  '${product.code} - ${product.name}\nQuantidade: ${product.quantity}\nPreço: R\$ ${utils.formatToBrazilianCurrency(product.price)}'),
              trailing: SizedBox(
                width: 50,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            selectedProdutcs.removeAt(index);
                            updateOrderTotalValue();
                          },
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          CosmeticSnackBar.showSnackBar(
                            context: context,
                            message: 'Produto removido.',
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
        },
      ),
    );
  }

  CosmeticFloatingActionButton buildCosmeticFloatingActionButton(
      BuildContext context) {
    return CosmeticFloatingActionButton(
      onPressed: () {
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
        var productSelected = Product(
          name: '',
          price: 0.0,
          code: 0,
          brandId: '',
          quantity: 1,
        );
        var valueController = MoneyMaskedTextController(
          decimalSeparator: ',',
          thousandSeparator: '.',
          precision: 2,
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
                          setState(
                            () {
                              productSelected = Product(
                                id: value.id,
                                name: value.name,
                                price: value.price,
                                code: value.code,
                                brandId: value.brandId,
                                creationTime: value.creationTime,
                                quantity: 1,
                              );

                              valueController.text = value.price.toString();
                            },
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
                            productSelected.price = formatProductPrice(value);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: cosmeticFormHeight - 20),
                      CosmeticTextFormField(
                        initialValue: productSelected.quantity.toString(),
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
                          } else if (int.parse(value) <= 0) {
                            return 'A quantidade deve ser maior que 0!';
                          } else {
                            productSelected.quantity = int.parse(value);
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
                                    addProduct(product: productSelected);
                                    updateOrderTotalValue();
                                  },
                                ),
                                Navigator.pop(context),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CosmeticSnackBar.showSnackBar(
                                    context: context,
                                    message: 'Produto adicionado.',
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
    );
  }

  addProduct({required Product product}) {
    var productExists = false;

    for (var prodct in selectedProdutcs) {
      if (prodct.id == product.id) {
        prodct.quantity = prodct.quantity! + product.quantity!;

        productExists = true;
        break;
      }
    }

    if (!productExists) {
      selectedProdutcs.add(product);
    }
  }

  void updateOrderTotalValue() {
    var newTotalValue = Decimal.zero;

    for (Product product in selectedProdutcs) {
      newTotalValue += Decimal.parse(product.price.toString()) *
          Decimal.parse(product.quantity!.toString());
    }
    setState(() {
      orderTotalValue = newTotalValue;
    });
  }

  double formatProductPrice(String price) {
    if (!price.contains('.')) {
      return double.parse(price.replaceAll(",", "."));
    } else {
      var formattedValue = price.replaceAll(",", ".").replaceAll(".", "");

      return double.parse(formattedValue) / 100;
    }
  }
}
