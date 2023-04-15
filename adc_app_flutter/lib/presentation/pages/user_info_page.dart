import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../widgets/user_details.dart';

class UserInfoPage extends StatelessWidget {
  final User user;
  const UserInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Info")),
      body: UserDetails(user: user),
    );
  }
}
