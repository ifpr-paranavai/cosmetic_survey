class User {
  dynamic id;
  late String name;
  late String email;
  late String? password;
  late DateTime? creationTime;

  User({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.creationTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'creationTime': creationTime,
    };
  }

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        creationTime: json['creationTime'],
      );
}
