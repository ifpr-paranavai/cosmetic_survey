import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/installments.dart';
import 'package:cosmetic_survey/src/core/constants/payment_type.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/entity/payment.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dropdown.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/ui/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class ViewUpdatePaymentDetails extends StatefulWidget {
  CosmeticOrder order;
  Payment payment;

  ViewUpdatePaymentDetails({
    Key? key,
    required this.order,
    required this.payment,
  }) : super(key: key);

  @override
  State<ViewUpdatePaymentDetails> createState() =>
      _ViewUpdatePaymentDetailsState();
}

class _ViewUpdatePaymentDetailsState extends State<ViewUpdatePaymentDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var utils = Utils();
  var orderDetails = OrderDetails();

  final _orderTotalValueController =
      MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final _installmentValueController =
      MoneyMaskedTextController(leftSymbol: 'R\$ ');

  var paymentType = [
    PaymentType.PAYMENT_CASH,
    PaymentType.PAYMENT_PIX,
    PaymentType.PAYMENT_CARD,
    PaymentType.PAYMENT_TRANSFER
  ];

  bool paid = false;
  var paymentInstallmentValue = 0.0;

  @override
  void initState() {
    super.initState();

    _installmentValueController.text =
        utils.formatToBrazilianCurrency(widget.payment.installmentValue!);
  }

  @override
  Widget build(BuildContext context) {
    _orderTotalValueController.text =
        utils.formatToBrazilianCurrency(widget.order.totalValue!);

    paid = widget.payment.paymentDate != null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
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
        'Parcela',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cosmeticSecondaryColor,
          fontSize: 25,
        ),
      ),
    );
  }

  Column buildPyamentOrderFields(BuildContext context) {
    return Column(
      children: [
        CosmeticTextFormField(
          initialValue: getInstallments(widget.order.installments!),
          textInputAction: TextInputAction.done,
          borderRadius: 10,
          keyboardType: TextInputType.number,
          readOnly: true,
          inputText: 'Quantidade de parcelas',
          icon: const Icon(
            Icons.payment_outlined,
            color: cosmeticSecondaryColor,
          ),
        ),
        const SizedBox(height: cosmeticFormHeight - 20),
        paid
            ? CosmeticTextFormField(
                initialValue: widget.payment.paymentType,
                textInputAction: TextInputAction.done,
                borderRadius: 10,
                keyboardType: TextInputType.number,
                readOnly: true,
                inputText: 'Forma de pagamento',
                icon: const Icon(
                  Icons.wallet_outlined,
                  color: cosmeticSecondaryColor,
                ),
              )
            : CosmeticDropdown(
                items: paymentType,
                hintText: 'Forma de pagamento',
                validator: (value) {
                  if (value == null) {
                    return 'Selecione uma opção!';
                  }
                  return null;
                },
                onItemChanged: (value) {
                  widget.payment.paymentType = value;
                },
              ),
        const SizedBox(height: cosmeticFormHeight - 20),
        CosmeticTextFormField(
          controller: _orderTotalValueController,
          textInputAction: TextInputAction.done,
          borderRadius: 10,
          keyboardType: TextInputType.number,
          readOnly: true,
          inputText: 'Valor total do pedido',
          icon: const Icon(
            Icons.payments_outlined,
            color: cosmeticSecondaryColor,
          ),
        ),
        const SizedBox(height: cosmeticFormHeight - 20),
        CosmeticTextFormField(
          controller: _installmentValueController,
          textInputAction: TextInputAction.done,
          borderRadius: 10,
          keyboardType: TextInputType.number,
          readOnly: paid,
          inputText: 'Valor da ${widget.payment.installmentNumber}ª parcela',
          icon: const Icon(
            Icons.price_change_outlined,
            color: cosmeticSecondaryColor,
          ),
          validator: (value) {
            var formattedValue = utils.formatValue(value.substring(3));

            var missingValue =
                utils.formatToBrazilianCurrency(widget.order.missingValue!);
            var formattedMissingvalue = utils.formatValue(missingValue);

            if (value == null && value.isEmpty) {
              return 'Informe o valor!';
            } else if (formattedValue > formattedMissingvalue) {
              return 'O valor máximo é: R\$ $missingValue';
            } else if (widget.payment.installmentNumber ==
                widget.order.installments) {
              if (formattedValue < formattedMissingvalue) {
                return 'O valor mínimo é: R\$ $missingValue';
              } else {
                paymentInstallmentValue = formattedValue;
              }
            } else {
              paymentInstallmentValue = formattedValue;
            }
            return null;
          },
        ),
        const SizedBox(height: cosmeticFormHeight - 20),
        CosmeticTextFormField(
          initialValue: paid
              ? Utils.formatDateDDMMYYYY(date: widget.payment.paymentDate!)
              : utils.getCurrentDateYearNumMonthDay(),
          inputText:
              'Data de pagamento ${widget.payment.installmentNumber}ª parcela',
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
          child: paid
              ? CosmeticElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonName: 'VOLTAR',
                )
              : CosmeticElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var now = DateTime.now();
                      widget.payment.paymentDate = now;
                      widget.payment.installmentValue = paymentInstallmentValue;

                      orderDetails.updatePaymentDetails(widget.payment);

                      widget.order.missingValue =
                          widget.order.missingValue! - paymentInstallmentValue;

                      var result = Result(now: now, order: widget.order);

                      Navigator.pop(context, result);
                      ScaffoldMessenger.of(context).showSnackBar(
                        CosmeticSnackBar.showSnackBar(
                          context: context,
                          message: 'Pagamento atualizado.',
                        ),
                      );
                    }
                  },
                  buttonName: 'CONFIRMAR PAGAMENTO',
                ),
        ),
      ],
    );
  }
}

getInstallments(int value) {
  switch (value) {
    case 0:
      return Installments.CASH_PAYMENT;
    case 1:
      return Installments.INSTALLMENTS_IN_1;
    case 2:
      return Installments.INSTALLMENTS_IN_2;
    case 3:
      return Installments.INSTALLMENTS_IN_3;
    case 4:
      return Installments.INSTALLMENTS_IN_4;
    case 5:
      return Installments.INSTALLMENTS_IN_5;
    case 6:
      return Installments.INSTALLMENTS_IN_6;
  }
}
