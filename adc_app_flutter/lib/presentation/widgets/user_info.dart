import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class UserInfo extends StatelessWidget {
  final User user;
  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Row(
          children: [
            Text(user.name),
            const SizedBox(
              width: 10,
            ),
            Text(parseRole(user.role))
          ],
        ),
        Row(
          children: [Text(user.name), Text(user.email)],
        )
      ]),
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
