class CurrentUser {
  dynamic id;
  late String name;
  late String email;
  late String? password;
  late DateTime? creationTime;
  late String? imagePath;

  CurrentUser({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.creationTime,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'creationTime': creationTime,
      'imagePath': imagePath,
    };
  }

  static CurrentUser fromJson(Map<String, dynamic> json) => CurrentUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        creationTime: json['creationTime'],
        imagePath: json['imagePath'],
      );
}
