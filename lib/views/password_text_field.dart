import 'package:bloc_app/strings.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key, required this.passwordController});
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      obscuringCharacter: "*",
      decoration: const InputDecoration(
        hintText: enterYourPassword,
      ),
    );
  }
}
