class UserModel {
  int? id;
  String username;
  String password;
  String email;
  String? cpf;
  String? phone;
  bool active = true;
  List roles;

  UserModel(
      {this.id,
      required this.username,
      required this.password,
      required this.email,
      this.cpf,
      this.phone,
      required this.roles});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "cpf": cpf,
      "phone": phone,
      "email": email,
      "roles": roles,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"]?.toInt(),
      password: map["password"] ?? "",
      username: map["username"] ?? "",
      email: map["email"] ?? "",
      cpf: map["cpf"] ?? "",
      phone: map["phone"] ?? "",
      roles: map["roles"] ?? "",
    );
  }
}
