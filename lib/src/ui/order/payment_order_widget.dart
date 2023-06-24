import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/installments.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dropdown.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../core/constants/payment_type.dart';
import '../../core/constants/sizes.dart';

class PaymentOrderWidget extends StatefulWidget {
  CosmeticOrder order;
  String totalValue;

  PaymentOrderWidget({
    Key? key,
    required this.order,
    required this.totalValue,
  }) : super(key: key);

  @override
  State<PaymentOrderWidget> createState() => _PaymentOrderWidgetState();
}

class _PaymentOrderWidgetState extends State<PaymentOrderWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var orderDetails = OrderDetails();
  var utils = Utils();
  final _installmentValueController =
      MoneyMaskedTextController(leftSymbol: 'R\$ ');

  var installments = [
    Installments.CASH_PAYMENT,
    Installments.INSTALLMENTS_IN_1,
    Installments.INSTALLMENTS_IN_2,
    Installments.INSTALLMENTS_IN_3,
    Installments.INSTALLMENTS_IN_4,
    Installments.INSTALLMENTS_IN_5,
    Installments.INSTALLMENTS_IN_6,
  ];

  var paymentType = [
    PaymentType.PAYMENT_CASH,
    PaymentType.PAYMENT_PIX,
    PaymentType.PAYMENT_CARD,
    PaymentType.PAYMENT_TRANSFER
  ];

  var paymentTypeSelected = '';
  var paymentInstallmentValue = 0.0;

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
            'Pagamento',
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
                child: buildPyamentOrderFields(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildPyamentOrderFields(BuildContext context) {
    return Column(
      children: [
        CosmeticDropdown(
          items: installments,
          hintText: 'Quantidade de parcelas',
          validator: (value) {
            if (value == null) {
              return 'Selecione uma opção!';
            }
            return null;
          },
          onItemChanged: (value) {
            setState(
              () {
                widget.order.installments = getInstallments(value);
                var installments = widget.order.installments;

                if (installments == 0) {
                  _installmentValueController.text = 'R\$ ${widget.totalValue}';
                } else {
                  _installmentValueController.text = getOrderInstallmentValue(
                      widget.totalValue, installments!);
                }
              },
            );
          },
        ),
        const SizedBox(height: cosmeticFormHeight - 20),
        CosmeticDropdown(
          items: paymentType,
          hintText: 'Forma de pagamento',
          validator: (value) {
            if (value == null) {
              return 'Selecione uma opção!';
            }
            return null;
          },
          onItemChanged: (value) {
            paymentTypeSelected = value;
          },
        ),
        const SizedBox(height: cosmeticFormHeight - 20),
        CosmeticTextFormField(
          initialValue: 'R\$ ${widget.totalValue}',
          inputText: 'Valor total do pedido',
          icon: const Icon(
            Icons.payments_outlined,
            color: cosmeticSecondaryColor,
          ),
          keyboardType: TextInputType.number,
          borderRadius: 10.0,
          readOnly: true,
        ),
        const SizedBox(height: cosmeticFormHeight - 20),
        CosmeticTextFormField(
          controller: _installmentValueController,
          inputText: widget.order.installments == 0
              ? 'Valor a receber'
              : 'Valor de pagamento 1ª parcela',
          validator: (value) {
            var orderTotalValue = utils.formatValue(widget.totalValue);
            var formattedValue = utils.formatValue(value.substring(3));

            var missingValue = utils.formatToBrazilianCurrency(orderTotalValue);

            if (value == null || value.isEmpty) {
              return 'Informe o valor!';
            } else if (formattedValue > orderTotalValue) {
              return 'O valor máximo é: R\$ $missingValue';
            } else if (widget.order.installments == 0) {
              if (formattedValue < orderTotalValue) {
                return 'O valor mínimo é: R\$ $missingValue';
              }
            } else {
              paymentInstallmentValue = formattedValue;
            }
            return null;
          },
          icon: const Icon(
            Icons.price_change_outlined,
            color: cosmeticSecondaryColor,
          ),
          keyboardType: TextInputType.number,
          borderRadius: 10.0,
          readOnly: false,
        ),
        const SizedBox(height: cosmeticFormHeight - 20),
        CosmeticTextFormField(
          initialValue: utils.getCurrentDateYearNumMonthDay(),
          inputText: 'Data de pagamento 1ª parcela',
          icon: const Icon(
            Icons.calendar_month_outlined,
            color: cosmeticSecondaryColor,
          ),
          keyboardType: TextInputType.number,
          borderRadius: 10.0,
          readOnly: true,
        ),
        const SizedBox(height: cosmeticFormHeight - 10),
        SizedBox(
          width: double.infinity,
          child: CosmeticElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.order.totalValue = utils.formatValue(widget.totalValue);
                widget.order.missingValue =
                    widget.order.totalValue! - paymentInstallmentValue;

                orderDetails.addOrderDetails(
                  order: widget.order,
                  payment: Payment(
                    installmentValue: paymentInstallmentValue,
                    paymentType: paymentTypeSelected,
                  ),
                );
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  CosmeticSnackBar.showSnackBar(
                    context: context,
                    message: 'Pedido criado.',
                  ),
                );
              }
            },
            buttonName: 'FINALIZAR PEDIDO',
          ),
        ),
      ],
    );
  }

  String getOrderInstallmentValue(String totalValue, int installments) {
    var orderValue = 0.0;
    var installmentValue = 0.0;

    if (!totalValue.contains('.')) {
      orderValue = double.parse(totalValue.replaceAll(",", "."));

      installmentValue = orderValue / installments;
    } else {
      var formattedValue = totalValue.replaceAll(",", ".").replaceAll(".", "");

      orderValue = double.parse(formattedValue) / 100;

      installmentValue = orderValue / installments;
    }
    paymentInstallmentValue = installmentValue;

    return utils.formatToBrazilianCurrency(installmentValue);
  }
}

getInstallments(String value) {
  switch (value) {
    case Installments.CASH_PAYMENT:
      return 0;
    case Installments.INSTALLMENTS_IN_1:
      return 1;
    case Installments.INSTALLMENTS_IN_2:
      return 2;
    case Installments.INSTALLMENTS_IN_3:
      return 3;
    case Installments.INSTALLMENTS_IN_4:
      return 4;
    case Installments.INSTALLMENTS_IN_5:
      return 5;
    case Installments.INSTALLMENTS_IN_6:
      return 6;
  }
}
