class Payment {
  dynamic id;
  dynamic orderId;
  late double? installmentValue;
  late DateTime? paymentDate;
  late int? installmentNumber;
  late String paymentType;

  Payment({
    this.id,
    this.orderId,
    this.installmentValue,
    this.paymentDate,
    this.installmentNumber,
    required this.paymentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'installmentValue': installmentValue,
      'paymentDate': paymentDate,
      'installmentNumber': installmentNumber,
      'paymentType': paymentType,
    };
  }

  static Payment fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        orderId: json['orderId'],
        installmentValue: json['installmentValue'],
        paymentDate: json['paymentDate']?.toDate(),
        installmentNumber: json['installmentNumber'],
        paymentType: json['paymentType'],
      );
}
