import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/masks.dart';
import 'package:cosmetic_survey/src/core/constants/order_status.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/core/entity/order.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/customer_details.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/order_details.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/report_details.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_date_picker.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dropdown.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/ui/order/order_card.dart';
import 'package:cosmetic_survey/src/ui/utils/pair.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _cicleController = TextEditingController();
  var customerDetails = CustomerDetails();
  var customers = <Customer>[];
  var reportDetails = ReportDetails();
  var selectedOrderStatus = '';
  var orderDetails = OrderDetails();
  var utils = Utils();
  late FutureBuilder callBuildReport;

  var orderStatus = [
    OrderStatus.EM_ANDAMENTO,
    OrderStatus.PAGO,
    OrderStatus.TODOS,
  ];

  @override
  void initState() {
    callBuildReport = buildReportData(
      startDate: DateTime(2023),
      endDate: DateTime.now(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    customers = customerDetails.searchAndConvertCustomers();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 4.0,
            left: cosmeticDefaultSize - 23,
            right: cosmeticDefaultSize - 23,
            bottom: cosmeticDefaultSize - 23,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CosmeticDatePicker(
                        controller: _startDateController,
                        inputText: 'Data Início',
                        icon: const Icon(Icons.calendar_month_outlined),
                        borderRadius: 10,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.next,
                        maskTextInputFormatter: CosmeticMasks.MASK_DATE,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe uma Data";
                          }
                          return null;
                        },
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2100),
                          );

                          if (selectedDate != null) {
                            setState(() {
                              _startDateController.text =
                                  Utils.formatDateDDMMYYYY(date: selectedDate);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: cosmeticFormHeight - 20),
                    Expanded(
                      child: CosmeticDatePicker(
                        controller: _endDateController,
                        inputText: 'Data Fim',
                        icon: const Icon(Icons.calendar_month_outlined),
                        borderRadius: 10,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.done,
                        maskTextInputFormatter: CosmeticMasks.MASK_DATE,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe uma Data";
                          }
                          return null;
                        },
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2100),
                          );

                          if (selectedDate != null) {
                            setState(() {
                              _endDateController.text =
                                  Utils.formatDateDDMMYYYY(date: selectedDate);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: cosmeticFormHeight - 20),
                Row(
                  children: [
                    const SizedBox(height: cosmeticFormHeight - 20),
                    Expanded(
                      child: CosmeticDropdown(
                        items: orderStatus,
                        hintText: 'Status Pedido',
                        validator: (value) {
                          return null;
                        },
                        onItemChanged: (value) {
                          selectedOrderStatus = value;
                        },
                      ),
                    ),
                    const SizedBox(width: cosmeticFormHeight - 20),
                    Expanded(
                      child: CosmeticTextFormField(
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
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: CosmeticElevatedButton(
                    buttonName: 'GERAR',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          callBuildReport = buildReportData(
                            startDate: utils
                                .parseTextFromDate(_startDateController.text),
                            endDate: utils
                                .parseTextFromDate(_endDateController.text),
                            cicle: _cicleController.text.isNotEmpty
                                ? int.parse(_cicleController.text)
                                : null,
                            orderStatus: selectedOrderStatus,
                          );
                        });
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const Divider(height: 50),
                Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: callBuildReport,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder buildReportData({
    required DateTime startDate,
    required DateTime endDate,
    int? cicle,
    String? orderStatus,
  }) {
    return FutureBuilder(
      future: reportDetails.buildReport(
        startDate: startDate,
        endDate: endDate,
        cicle: cicle,
        orderStatus: orderStatus,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Ocorreu um erro ao carregar registros do Relatório...',
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data.orders.length != 0) {
            final pair = snapshot.data! as Pair;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Valor total: ',
                          ),
                          TextSpan(
                            text:
                                'R\$ ${utils.formatToBrazilianCurrency(pair.value.toDouble())}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 1.2,
                  child: ListView.builder(
                    itemCount: pair.orders.length,
                    itemBuilder: (context, index) {
                      var currentOrder = pair.orders[index];

                      CosmeticOrder order = CosmeticOrder(
                        id: currentOrder.id,
                        customerId: currentOrder.customerId,
                        cicle: currentOrder.cicle,
                        saleDate: currentOrder.saleDate,
                        comments: currentOrder.comments,
                        installments: currentOrder.installments,
                        totalValue: currentOrder.totalValue,
                        missingValue: currentOrder.missingValue,
                      );

                      return OrderCard(
                        order: order,
                        customers: customers,
                        isReport: true,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text(
                'Nenhum registro encontrado com o filtro atual.',
              ),
            );
          }
        } else {
          return const CosmeticCircularIndicator();
        }
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Relatório',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cosmeticSecondaryColor,
          fontSize: 25,
        ),
      ),
    );
  }
}
