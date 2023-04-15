import 'package:adc_app_flutter/domain/logic/get_user.dart';
import 'package:adc_app_flutter/presentation/pages/user_info_page.dart';
import 'package:adc_app_flutter/presentation/widgets/pop_up.dart';
import 'package:flutter/material.dart';

import '../../domain/logic/remove_user.dart';
import '../../domain/repositories/repository.dart';
import '../pages/login_page.dart';

class SearchUserWidget extends StatelessWidget {
  final Repository repository;

  const SearchUserWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();

    return AlertDialog(
      title: const Text("Search User"),
      content: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  GetUser(repository)
                      .call(usernameController.text)
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
                            ScaffoldMessenger.of(context).showSnackBar(PopUp(
                                message: "User retreived.", isGood: true));
                            usernameController.clear();
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserInfoPage(user: r),
                                ));
                          }));
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
