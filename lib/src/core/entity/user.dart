class User {
  dynamic id;
  late String name;
  late String email;
  late String password;
  late String creationTime;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.creationTime,
  });
}
