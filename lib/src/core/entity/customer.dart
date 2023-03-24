class Customer {
  dynamic id;
  late String name;
  late String cpf;
  String? cellNumber;
  late DateTime? creationTime;

  Customer({
    this.id,
    required this.name,
    required this.cpf,
    this.cellNumber,
    this.creationTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'cellNumber': cellNumber,
      'creationTime': creationTime,
    };
  }

  static Customer fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'],
        cpf: json['cpf'],
        cellNumber: json['cellNumber'],
        creationTime: json['creationTime'].toDate(),
      );
}
