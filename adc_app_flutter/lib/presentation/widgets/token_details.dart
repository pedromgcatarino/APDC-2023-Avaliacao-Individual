import 'package:flutter/material.dart';

import '../../domain/entities/auth_token.dart';

class TokenDetailsWidget extends StatelessWidget {
  final AuthToken token;
  const TokenDetailsWidget({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Token Details"),
      content: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Username: ${token.username}"),
            const SizedBox(height: 10),
            Text("Role: ${parseRole(token.role)}"),
            const SizedBox(height: 10),
            Text("Creation time: ${token.creationTime}"),
            const SizedBox(height: 10),
            Text("Expiration time: ${token.expirationTime}"),
          ],
        ),
      ),
    );
  }

  String parseRole(int role) {
    switch (role) {
      case 0:
        return "USER";
      case 1:
        return "GBO";
      case 2:
        return "GS";
      case 3:
        return "SU";
      default:
        return "Invalid";
    }
  }
}
