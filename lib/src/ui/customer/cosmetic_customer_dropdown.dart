import 'package:cosmetic_survey/src/core/entity/customer.dart';
import 'package:cosmetic_survey/src/ui/utils/dropdown_style.dart';
import 'package:flutter/material.dart';

class CosmeticCustomerDropdown extends StatefulWidget {
  var customers = <Customer>[];
  ValueChanged<Customer> onCustomerChanged;
  FormFieldValidator validator;

  CosmeticCustomerDropdown({
    Key? key,
    required this.customers,
    required this.onCustomerChanged,
    required this.validator,
  }) : super(key: key);

  @override
  State<CosmeticCustomerDropdown> createState() =>
      _CosmeticCustomerDropdownState();
}

class _CosmeticCustomerDropdownState extends State<CosmeticCustomerDropdown> {
  var uiUtil = UiUtil();

  @override
  Widget build(BuildContext context) {
    Customer selectedCustomer;

    return DropdownButtonFormField<Customer>(
      value: null,
      decoration: uiUtil.dropdownStyle(label: 'Selecione um Cliente'),
      validator: widget.validator,
      isExpanded: true,
      items: widget.customers.map((Customer customer) {
        return DropdownMenuItem<Customer>(
          value: customer,
          child: Text(customer.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (Customer? customer) {
        setState(() {
          selectedCustomer = customer!;
        });
        widget.onCustomerChanged(customer!);
      },
    );
  }
}
