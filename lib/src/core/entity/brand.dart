class Brand {
  dynamic id;
  late String name;

  Brand({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Brand fromJson(Map<String, dynamic> json) => Brand(
        id: json['id'],
        name: json['name'],
      );
}
