class Customer {
  dynamic id;
  late String name;
  late String cpf;
  String? cellNumber;

  Customer({
    this.id,
    required this.name,
    required this.cpf,
    this.cellNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'cellNumber': cellNumber,
    };
  }

  static Customer fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'],
        cpf: json['cpf'],
        cellNumber: json['cellNumber'],
      );
}
