import 'package:bloc_app/views/email_text_fields.dart';
import 'package:bloc_app/views/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import "package:flutter_hooks/flutter_hooks.dart";
import 'package:flutter/src/widgets/framework.dart';

import 'login_button.dart';

class LoginView extends StatelessWidget {
  final OnLoginTapped onLoginTapped;
  const LoginView({super.key, required this.onLoginTapped});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: "asda");
    final passwordController = useTextEditingController(text: "asda");
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          EmailTextField(emailController: emailController),
          PasswordTextField(passwordController: passwordController),
          LoginButton(
            emailController: emailController,
            passwordController: passwordController,
            onLoginTapped: onLoginTapped,
          )
        ],
      ),
    );
  }
}
