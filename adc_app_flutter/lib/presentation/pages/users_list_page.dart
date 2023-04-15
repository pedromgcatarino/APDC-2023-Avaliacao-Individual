import 'package:adc_app_flutter/presentation/widgets/user_info.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class UsersListPage extends StatelessWidget {
  final List<User> users;
  const UsersListPage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => UserInfo(user: users[index])),
    );
  }
}
