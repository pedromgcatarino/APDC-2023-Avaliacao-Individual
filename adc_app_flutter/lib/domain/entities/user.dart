class User {
  String username;
  String password;
  String email;
  String name;
  bool isPrivate;
  String phoneNumber;
  String mobilePhoneNumber;
  String occupation;
  String workplace;
  String address;
  String nif;
  String profilePicPath;
  bool isActive;
  int role;

  User(
      {required this.username,
      required this.password,
      required this.email,
      required this.name,
      required this.isPrivate,
      required this.phoneNumber,
      required this.mobilePhoneNumber,
      required this.occupation,
      required this.workplace,
      required this.address,
      required this.nif,
      required this.profilePicPath,
      required this.isActive,
      required this.role});
}
