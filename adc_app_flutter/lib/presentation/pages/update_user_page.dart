import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';
import '../../domain/logic/change_attributes.dart';
import '../../domain/repositories/repository.dart';
import '../widgets/pop_up.dart';
import '../widgets/text_input.dart';
import 'login_page.dart';

class UpdateUserPage extends StatelessWidget {
  final Repository repository;
  const UpdateUserPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final _updatedFormKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final mobileController = TextEditingController();
    final occupationController = TextEditingController();
    final workplaceController = TextEditingController();
    final addressController = TextEditingController();
    final nifController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Update User Attributes")),
      body: Center(
        child: Container(
          height: 700,
          width: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Form(
              key: _updatedFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Input(
                      label: "Username",
                      isRequired: true,
                      controller: usernameController),
                  const SizedBox(height: 10),
                  Input(
                      label: "Name",
                      isRequired: true,
                      controller: nameController),
                  const SizedBox(height: 10),
                  Input(
                      label: "Email",
                      isRequired: true,
                      controller: emailController),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      UserModel updatedUser = UserModel(
                          username: usernameController.text,
                          password: "password",
                          confirmation: "password",
                          email: emailController.text,
                          name: nameController.text,
                          isPrivate: false,
                          phoneNumber: phoneNumberController.text,
                          mobilePhoneNumber: mobileController.text,
                          occupation: occupationController.text,
                          workplace: workplaceController.text,
                          address: addressController.text,
                          nif: nifController.text,
                          profilePicPath: "",
                          isActive: false,
                          role: 0);
                      ChangeAttributes(
                              repository)
                          .call(updatedUser)
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
                              },
                                  (r) => ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(PopUp(
                                          message: "User updated.",
                                          isGood: true))));
                      _updatedFormKey.currentState!.reset();
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
