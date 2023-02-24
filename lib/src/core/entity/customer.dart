class Customer {
  dynamic id;
  late String name;
  late String cpf;

  Customer({
    this.id,
    required this.name,
    required this.cpf,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
    };
  }

  static Customer fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'],
        cpf: json['cpf'],
      );
}
