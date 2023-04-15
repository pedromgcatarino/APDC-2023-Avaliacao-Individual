import 'package:flutter/material.dart';

import '../../data/models/password_input_model.dart';
import '../../domain/logic/change_password.dart';
import '../../domain/repositories/repository.dart';
import '../pages/login_page.dart';
import 'pop_up.dart';

class ChangePasswordWidget extends StatelessWidget {
  final Repository repository;
  const ChangePasswordWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final _passwordFormKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmationController = TextEditingController();

    return AlertDialog(
      title: const Text("Change Password"),
      content: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _passwordFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Old Password"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("New Password"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (value.length < 8) {
                      return 'Password must have at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: confirmationController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Confirmation"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (value != newPasswordController.text) {
                      return 'New password and confirmation do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_passwordFormKey.currentState!.validate()) {
                      ChangePassword(repository)
                          .call(PasswordInputModel(
                              oldPassword: oldPasswordController.text,
                              newPassword: newPasswordController.text,
                              confirmation: confirmationController.text))
                          .then((value) => value.fold((l) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    PopUp(message: l.msg, isGood: false));
                                if (l.code == 0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const LoginPage())));
                                }
                              }, (r) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    PopUp(
                                        message: "Password changed.",
                                        isGood: true));
                                _passwordFormKey.currentState!.reset();
                                Navigator.pop(context);
                              }));
                    }
                  },
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
