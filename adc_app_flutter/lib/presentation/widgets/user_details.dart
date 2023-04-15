import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Icon(Icons.person, size: 100),
        ),
        Text("Username: ${user.username}", textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Email: ${user.email}", textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Name: ${user.name}", textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Account State: ${user.isActive ? "ACTIVE" : "INACTIVE"}",
            textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Role: ${parseRole(user.role)}", textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Profile State: ${user.isPrivate ? "PRIVATE" : "PUBLIC"}",
            textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Phone Number: ${user.phoneNumber}", textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Mobile Phone Number: ${user.mobilePhoneNumber}",
            textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Occupation: ${user.occupation}", textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Workplace: ${user.workplace}", textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("Address: ${user.address}", textAlign: TextAlign.start),
        const SizedBox(height: 10),
        Text("NIF: ${user.nif}", textAlign: TextAlign.start),
      ],
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
