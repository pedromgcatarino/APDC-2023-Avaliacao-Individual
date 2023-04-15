import 'package:adc_app_flutter/presentation/widgets/pop_up.dart';
import 'package:flutter/material.dart';

import '../../domain/logic/remove_user.dart';
import '../../domain/repositories/repository.dart';
import '../pages/login_page.dart';

class RemoveUserWidget extends StatelessWidget {
  final Repository repository;

  const RemoveUserWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final removeUsernameController = TextEditingController();

    return AlertDialog(
      title: const Text("Remove User"),
      content: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: removeUsernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  RemoveUser(repository)
                      .call(removeUsernameController.text)
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
                                PopUp(message: "User removed.", isGood: true));
                            removeUsernameController.clear();
                            Navigator.pop(context);
                          }));
                },
                child: const Text('Remove'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
