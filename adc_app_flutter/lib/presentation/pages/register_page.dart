import 'package:adc_app_flutter/data/models/user_model.dart';
import 'package:adc_app_flutter/domain/entities/user.dart';
import 'package:adc_app_flutter/domain/logic/register.dart';
import 'package:adc_app_flutter/domain/logic/remove_user.dart';
import 'package:adc_app_flutter/presentation/pages/home_page.dart';
import 'package:adc_app_flutter/presentation/pages/login_page.dart';
import 'package:adc_app_flutter/presentation/provider/providers.dart';

import 'package:adc_app_flutter/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/logic/get_user.dart';
import '../../domain/logic/show_token.dart';
import '../widgets/choice_button.dart';
import '../widgets/pop_up.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmationController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final mobileController = TextEditingController();
    final occupationController = TextEditingController();
    final workplaceController = TextEditingController();
    final addressController = TextEditingController();
    final nifController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 700,
          width: 500,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.brown, width: 2))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Input(
                              label: "Username*",
                              isRequired: true,
                              controller: usernameController),
                          const SizedBox(height: 10),
                          Input(
                              label: "Name*",
                              isRequired: true,
                              controller: nameController),
                          const SizedBox(height: 10),
                          Input(
                              label: "Email*",
                              isRequired: true,
                              controller: emailController),
                          const SizedBox(height: 10),
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
                              labelText: 'Password*',
                              hintText: 'Required',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: confirmationController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value != passwordController.text) {
                                return 'Password and Confirmation do not match';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirmation*',
                              hintText: 'Required',
                            ),
                          ),
                          const SizedBox(height: 10),
                          const ChoiceButton(),
                          const SizedBox(height: 10),
                          Input(
                              label: "Phone Number",
                              isRequired: false,
                              controller: phoneNumberController),
                          const SizedBox(height: 10),
                          Input(
                              label: "Mobile Number",
                              isRequired: false,
                              controller: mobileController),
                          const SizedBox(height: 10),
                          Input(
                              label: "Occupation",
                              isRequired: false,
                              controller: occupationController),
                          const SizedBox(height: 10),
                          Input(
                              label: "Workplace",
                              isRequired: false,
                              controller: workplaceController),
                          const SizedBox(height: 10),
                          Input(
                              label: "Address",
                              isRequired: false,
                              controller: addressController),
                          const SizedBox(height: 10),
                          Input(
                              label: "NIF",
                              isRequired: false,
                              controller: nifController),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              UserModel user = UserModel(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                  confirmation: confirmationController.text,
                                  email: emailController.text,
                                  name: nameController.text,
                                  isPrivate: ref
                                      .read(Providers.profileStateProvider)[1],
                                  phoneNumber: phoneNumberController.text,
                                  mobilePhoneNumber: mobileController.text,
                                  occupation: occupationController.text,
                                  workplace: workplaceController.text,
                                  address: addressController.text,
                                  nif: nifController.text,
                                  profilePicPath: "something",
                                  isActive: false,
                                  role: 0);
                              Register(ref.read(Providers.repositoryProvider))
                                  .call(user)
                                  .then((value) => value.fold(
                                          (l) => ScaffoldMessenger.of(context)
                                              .showSnackBar(PopUp(
                                                  message: l.msg,
                                                  isGood: false)), (r) {
                                        GetUser(ref.read(
                                                Providers.repositoryProvider))
                                            .call(usernameController.text)
                                            .then((value) => value.fold(
                                                    (l) => ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(PopUp(
                                                            message: l.msg,
                                                            isGood: false)),
                                                    (r) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(PopUp(
                                                          message:
                                                              "Registered successfully",
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
                          child: const Text("Register")),
                    ),
                    InkWell(
                      child: const Text("Already have an account? Login"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const LoginPage()))),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
