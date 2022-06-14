import 'package:fasko_mobile/pages/auth/login.dart';
import 'package:fasko_mobile/pages/auth/signup.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showLogIn = true;

  void toggleView() {
    setState(() {
      showLogIn = !showLogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogIn
        ? LogInPage(toggleView: toggleView)
        : SignUpPage(toggleView: toggleView);
  }
}
