import 'package:adc_app_flutter/domain/entities/user.dart';

class UserModel {
  String username;
  String password;
  String confirmation;
  String email;
  String name;
  bool? isPrivate;
  String? phoneNumber;
  String? mobilePhoneNumber;
  String? occupation;
  String? workplace;
  String? address;
  String? nif;
  String? profilePicPath;
  bool isActive;
  int role;

  UserModel(
      {required this.username,
      required this.password,
      required this.confirmation,
      required this.email,
      required this.name,
      this.isPrivate,
      this.phoneNumber,
      this.mobilePhoneNumber,
      this.occupation,
      this.workplace,
      this.address,
      this.nif,
      this.profilePicPath,
      required this.isActive,
      required this.role});

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
      username: json["username"],
      password: json["password"],
      confirmation: json["password"],
      email: json["email"],
      name: json["name"],
      isPrivate: json["isPrivate"],
      phoneNumber: json["phone_number"],
      mobilePhoneNumber: json["mobile_phone_number"],
      occupation: json["occupation"],
      workplace: json["workplace"],
      address: json["address"],
      nif: json["nif"],
      profilePicPath: json["profile_pic_path"],
      isActive: json["isActive"],
      role: json["role"]);

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "confirmation": confirmation,
        "email": email,
        "name": name,
        "isPrivate": isPrivate,
        "phone_number": phoneNumber,
        "mobile_phone_number": mobilePhoneNumber,
        "occupation": occupation,
        "workplace": workplace,
        "address": address,
        "nif": nif,
        "profile_pic_path": profilePicPath,
        "isActive": isActive,
        "role": role
      };

  User toEntity() => User(
      username: username,
      password: password,
      email: email,
      name: name,
      isPrivate: isPrivate ?? false,
      phoneNumber: phoneNumber ?? "",
      mobilePhoneNumber: mobilePhoneNumber ?? "",
      occupation: occupation ?? "",
      workplace: workplace ?? "",
      address: address ?? "",
      nif: nif ?? "",
      profilePicPath: profilePicPath ?? "",
      isActive: isActive,
      role: role);
}
