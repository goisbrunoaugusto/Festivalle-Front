class UserRequestModel {
  String? username;
  String? password;
  String? token;

  UserRequestModel({this.username, this.password, this.token});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': username,
      'password': password,
    };

    return map;
  }

  factory UserRequestModel.fromJson(Map<String, dynamic> map) {
    return UserRequestModel(
      token: map["token"],
    );
  }

  String? getToken() {
    return token;
  }
}
