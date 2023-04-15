import 'package:adc_app_flutter/domain/logic/show_token.dart';
import 'package:adc_app_flutter/domain/repositories/repository.dart';
import 'package:adc_app_flutter/presentation/pages/update_user_page.dart';
import 'package:adc_app_flutter/presentation/widgets/pop_up.dart';
import 'package:adc_app_flutter/presentation/widgets/remove_user_widget.dart';
import 'package:flutter/material.dart';

import '../../domain/logic/list_users.dart';
import '../../domain/logic/logout.dart';
import '../pages/login_page.dart';
import '../pages/users_list_page.dart';
import 'change_password_widget.dart';
import 'change_roles_widget.dart';
import 'search_user_widget.dart';
import 'token_details.dart';

class OperationsWidget extends StatelessWidget {
  final Repository repository;
  const OperationsWidget({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: ((context) {
                    return RemoveUserWidget(
                      repository: repository,
                    );
                  })),
              child: const Text("Remove User")),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              onPressed: () =>
                  ListUsers(repository).call().then((value) => value.fold(
                        (l) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              PopUp(message: l.msg, isGood: false));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const LoginPage())));
                        },
                        (r) => showDialog(
                            context: context,
                            builder: ((context) {
                              return UsersListPage(users: r);
                            })),
                      )),
              child: const Text("List Users")),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          UpdateUserPage(repository: repository)))),
              child: const Text("Update User Attributes")),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: ((context) {
                    return ChangeRolesWidget(
                      repository: repository,
                    );
                  })),
              child: const Text("Update User Roles")),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: ((context) {
                    return ChangePasswordWidget(
                      repository: repository,
                    );
                  })),
              child: const Text("Change Password")),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: ((context) {
                    return SearchUserWidget(
                      repository: repository,
                    );
                  })),
              child: const Text("Search User")),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              onPressed: () =>
                  ShowToken(repository).call().then((value) => value.fold(
                        (l) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              PopUp(message: l.msg, isGood: false));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const LoginPage())));
                        },
                        (r) => showDialog(
                            context: context,
                            builder: ((context) {
                              return TokenDetailsWidget(
                                token: r,
                              );
                            })),
                      )),
              child: const Text("Show Token")),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
              onPressed: () =>
                  Logout(repository).call().then((value) => value.fold((l) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(PopUp(message: l.msg, isGood: false));
                        if (l.code == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const LoginPage())));
                        }
                      }, (r) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            PopUp(message: "Logged out", isGood: true));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const LoginPage())));
                      })),
              child: const Text("Logout")),
        ),
      ],
    );
  }
}
