class LoginData {
  String username;
  String password;

  LoginData({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
