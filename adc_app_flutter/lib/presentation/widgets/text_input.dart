import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;

  const Input(
      {super.key,
      required this.label,
      required this.isRequired,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (isRequired) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        }
        return null;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        hintText: isRequired ? 'Required' : 'Optional',
      ),
    );
  }
}
