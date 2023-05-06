import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/customer_details.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/ui/order/installments_widget.dart';
import 'package:flutter/material.dart';

class ViewUpdateOrderDetails extends StatefulWidget {
  dynamic orderId;

  ViewUpdateOrderDetails({Key? key, required this.orderId}) : super(key: key);

  @override
  State<ViewUpdateOrderDetails> createState() => _ViewUpdateOrderDetailsState();
}

class _ViewUpdateOrderDetailsState extends State<ViewUpdateOrderDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentsController = TextEditingController();

  var utils = Utils();
  var orderDetails = OrderDetails();
  var customerDetails = CustomerDetails();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(cosmeticDefaultSize),
            child: buildBody(),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
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
        'Detalhes do Pedido',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cosmeticSecondaryColor,
          fontSize: 25,
        ),
      ),
    );
  }

  FutureBuilder<List<dynamic>> buildBody() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait(
        [
          orderDetails.readOrderDetailsById(widget.orderId),
          orderDetails.getOrderProductQuantity(widget.orderId),
          customerDetails.getOrderCustomer(widget.orderId),
          orderDetails.getOrderProducts(widget.orderId),
        ],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Ocorreu um erro ao carregar detalhes do Pedido...',
            ),
          );
        } else if (snapshot.hasData) {
          final order = snapshot.data![0] as CosmeticOrder;
          final orderProductQuantity = snapshot.data![1] as int;
          final orderCustomer = snapshot.data![2] as Customer;
          final products = snapshot.data![3] as List<Product>;

          _commentsController.text = order.comments!;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Data da Venda: ${Utils.formatDate(date: order.saleDate!)}',
                    ),
                  ],
                ),
                const SizedBox(height: cosmeticFormHeight - 20),
                CosmeticTextFormField(
                  initialValue: orderCustomer.name,
                  textInputAction: TextInputAction.done,
                  borderRadius: 10,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  inputText: 'Cliente',
                  icon: const Icon(
                    Icons.person_outline_rounded,
                    color: cosmeticSecondaryColor,
                  ),
                ),
                const SizedBox(height: cosmeticFormHeight - 20),
                CosmeticTextFormField(
                  initialValue: order.cicle.toString(),
                  textInputAction: TextInputAction.done,
                  borderRadius: 10,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  inputText: 'Ciclo',
                  icon: const Icon(
                    Icons.menu_open_outlined,
                    color: cosmeticSecondaryColor,
                  ),
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
                            text: '$orderProductQuantity',
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
                                'R\$ ${utils.formatToBrazilianCurrency(order.totalValue!)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                buildSelectedProductsListView(products),
                const Divider(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CosmeticElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        order.comments = _commentsController.text;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InstallmentsWidget(order: order),
                          ),
                        );
                      }
                    },
                    buttonName: 'VISUALIZAR PAGAMENTOS',
                  ),
                ),
              ],
            ),
          );
        } else {
          return const CosmeticCircularIndicator();
        }
      },
    );
  }

  SizedBox buildSelectedProductsListView(List<Product> products) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.9,
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          var product = products[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                '${product.code} - ${product.name}\nQuantidade: ${product.quantity}\nPreço: R\$ ${utils.formatToBrazilianCurrency(product.price)}',
              ),
            ),
          );
        },
      ),
    );
  }
}
