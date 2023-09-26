import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/utils/utils.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_date_picker.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  final _initialDateController = TextEditingController();
  final _finalDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Container(
        padding: const EdgeInsets.only(
          top: 4.0,
          left: cosmeticDefaultSize,
          right: cosmeticDefaultSize,
          bottom: cosmeticDefaultSize,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CosmeticDatePicker(
                inputText: 'Data Início',
                icon: const Icon(Icons.calendar_month_outlined),
                borderRadius: 10,
                textInputAction: TextInputAction.next,
                onTap: () async {
                  var selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      _initialDateController.text =
                          Utils.formatDateDDMMYYYY(date: selectedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: cosmeticFormHeight - 20),
              CosmeticDatePicker(
                inputText: 'Data Fim',
                icon: const Icon(Icons.calendar_month_outlined),
                borderRadius: 10,
                textInputAction: TextInputAction.done,
                onTap: () async {
                  var selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      _finalDateController.text =
                          Utils.formatDateDDMMYYYY(date: selectedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CosmeticElevatedButton(
                  buttonName: 'GERAR',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //TODO gerar relatório
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Relatórios',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cosmeticSecondaryColor,
          fontSize: 25,
        ),
      ),
    );
  }
}
