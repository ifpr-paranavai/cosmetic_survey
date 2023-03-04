class Payment {
  dynamic id;
  late double amountReceivable;
  late double amountPaid;
  late DateTime receiptDate;
  late DateTime paymentDate;
  late int installments;

  Payment({
    this.id,
    required this.amountReceivable,
    required this.amountPaid,
    required this.receiptDate,
    required this.paymentDate,
    required this.installments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountReceivable': amountReceivable,
      'amountPaid': amountPaid,
      'receiptDate': receiptDate,
      'paymentDate': paymentDate,
      'installments': installments,
    };
  }

  static Payment fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        amountReceivable: json['amountReceivable'],
        amountPaid: json['amountPaid'],
        receiptDate: json['receiptDate'],
        paymentDate: json['paymentDate'],
        installments: json['installments'],
      );
}
