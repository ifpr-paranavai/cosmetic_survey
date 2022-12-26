class Customer {
  dynamic id;
  late String name;
  late String cpfCnpj;

  Customer({
    this.id,
    required this.name,
    required this.cpfCnpj,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpfCnpj': cpfCnpj,
    };
  }

  static Customer fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'],
        cpfCnpj: json['cpfCnpj'],
      );
}
