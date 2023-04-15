import 'package:adc_app_flutter/domain/entities/auth_token.dart';

class AuthTokenModel {
  String username;
  int role;
  int creationTime;
  int expirationTime;
  String magicNumber;

  AuthTokenModel(
      {required this.username,
      required this.role,
      required this.creationTime,
      required this.expirationTime,
      required this.magicNumber});

  factory AuthTokenModel.fromJson(Map<dynamic, dynamic> json) => AuthTokenModel(
      username: json["username"],
      role: json["role"],
      creationTime: json["creationTime"],
      expirationTime: json["expirationTime"],
      magicNumber: json["magicNumber"]);

  AuthToken toEntity() {
    return AuthToken(
        username: username,
        role: role,
        creationTime: creationTime,
        expirationTime: expirationTime,
        magicNumber: magicNumber);
  }
}
