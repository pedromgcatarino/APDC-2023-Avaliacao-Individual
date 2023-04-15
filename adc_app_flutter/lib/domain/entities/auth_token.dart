class AuthToken {
  String username;
  int role;
  int creationTime;
  int expirationTime;
  String magicNumber;

  AuthToken(
      {required this.username,
      required this.role,
      required this.creationTime,
      required this.expirationTime,
      required this.magicNumber});
}
