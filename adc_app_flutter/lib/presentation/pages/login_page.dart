import 'package:adc_app_flutter/domain/logic/get_user.dart';
import 'package:adc_app_flutter/domain/logic/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/login_data.dart';
import '../provider/providers.dart';
import '../widgets/pop_up.dart';
import '../widgets/text_input.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.brown, width: 2))),
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Input(
                      label: "Username",
                      isRequired: true,
                      controller: usernameController),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (value.length < 8) {
                        return 'Password must have at least 8 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Required',
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Login(ref.read(Providers.repositoryProvider))
                              .call(LoginData(
                                  password: passwordController.text,
                                  username: usernameController.text))
                              .then((value) => value.fold(
                                      (l) => ScaffoldMessenger.of(context)
                                          .showSnackBar(PopUp(
                                              message: l.msg,
                                              isGood: false)), (r) {
                                    GetUser(ref
                                            .read(Providers.repositoryProvider))
                                        .call(usernameController.text)
                                        .then((value) => value.fold(
                                                (l) => ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(PopUp(
                                                        message: l.msg,
                                                        isGood: false)), (r) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(PopUp(
                                                      message:
                                                          "Logged in successfully",
                                                      isGood: true));
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          HomePage(
                                                            user: r,
                                                          ))));
                                            }));
                                  }));
                        }
                      },
                      child: const Text("Login")),
                  InkWell(
                    child: const Text("Dont have an account yet? Register"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const RegisterPage()))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
