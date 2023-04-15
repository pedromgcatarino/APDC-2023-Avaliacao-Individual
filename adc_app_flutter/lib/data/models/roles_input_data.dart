class RolesInputData {
  String username;
  int newRole;
  bool newState;

  RolesInputData(
      {required this.username, required this.newRole, required this.newState});

  Map<String, dynamic> toJson() => {
        "username": username,
        "newRole": newRole,
        "newState": newRole,
      };
}
