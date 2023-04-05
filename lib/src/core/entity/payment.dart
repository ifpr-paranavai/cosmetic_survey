class Payment {
  dynamic id;
  late double installmentValue;
  late DateTime? paymentDate;
  late int installmentNumber;
  late String paymentType;

  Payment({
    this.id,
    required this.installmentValue,
    this.paymentDate,
    required this.installmentNumber,
    required this.paymentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountReceivable': installmentValue,
      'paymentDate': paymentDate,
      'installments': installmentNumber,
      'paymentType': paymentType,
    };
  }

  static Payment fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        installmentValue: json['installmentValue'],
        paymentDate: json['paymentDate'],
        installmentNumber: json['installments'],
        paymentType: json['paymentType'],
      );
}
