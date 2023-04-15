class PasswordInputModel {
  String oldPassword;
  String newPassword;
  String confirmation;

  PasswordInputModel(
      {required this.oldPassword,
      required this.newPassword,
      required this.confirmation});

  Map<String, dynamic> toJson() => {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmation": confirmation,
      };
}
