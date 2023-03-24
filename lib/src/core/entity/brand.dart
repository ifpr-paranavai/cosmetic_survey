class Brand {
  dynamic id;
  late String name;
  late DateTime? creationTime;

  Brand({
    this.id,
    required this.name,
    this.creationTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creationTime': creationTime,
    };
  }

  static Brand fromJson(Map<String, dynamic> json) => Brand(
        id: json['id'],
        name: json['name'],
        creationTime: json['creationTime'].toDate(),
      );
}
