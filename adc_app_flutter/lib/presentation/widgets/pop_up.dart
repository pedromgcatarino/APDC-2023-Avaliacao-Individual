import 'package:flutter/material.dart';

class PopUp extends SnackBar {
  final String message;
  final bool isGood;

  PopUp({super.key, required this.message, required this.isGood})
      : super(
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: isGood ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        );
}
