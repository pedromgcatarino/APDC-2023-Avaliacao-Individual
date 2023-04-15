import 'package:adc_app_flutter/data/models/roles_input_data.dart';
import 'package:adc_app_flutter/domain/logic/change_roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/repository.dart';
import '../pages/login_page.dart';
import '../provider/providers.dart';
import 'pop_up.dart';

class ChangeRolesWidget extends ConsumerWidget {
  final Repository repository;

  const ChangeRolesWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    return AlertDialog(
      title: const Text("Change Password"),
      content: SizedBox(
        height: 300,
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text("New Role: "),
                  DropdownButton<String>(
                    value: ref.watch(Providers.selectedRoleProvider),
                    items: <String>['USER', 'GBO', 'GS', 'SU']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      ref.read(Providers.selectedRoleProvider.notifier).state =
                          newValue!;
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text("New State"),
                  DropdownButton<String>(
                    value: ref.watch(Providers.selectedStateProvider),
                    items: <String>['INACTIVE', 'ACTIVE']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      ref.read(Providers.selectedStateProvider.notifier).state =
                          newValue!;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ChangeRoles(repository)
                      .call(RolesInputData(
                          username: usernameController.text,
                          newRole: parseRole(
                              ref.read(Providers.selectedRoleProvider)),
                          newState: ref.read(Providers.selectedStateProvider) ==
                              'ACTIVE'))
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
                                PopUp(message: "Roles changed.", isGood: true));
                            usernameController.clear();
                            Navigator.pop(context);
                          }));
                },
                child: const Text('Change'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int parseRole(String role) {
  switch (role) {
    case 'USER':
      return 0;
    case 'GBO':
      return 1;
    case 'GS':
      return 2;
    case 'SU':
      return 3;
    default:
      return 0;
  }
}
