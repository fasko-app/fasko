import 'package:fasko_mobile/services/auth.dart';
import 'package:fasko_mobile/widgets/password_input.dart';
import 'package:fasko_mobile/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:fasko_mobile/widgets/bar.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleView;

  const SignUpPage({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordInvisible = true;
  bool isConfirmPasswordInvisible = true;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';

  String message = "Verification email will be sended after sign up";

  @override
  void setState(VoidCallback fn) {
    // check is widget in the tree
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FaskoAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.3,
                  ),
                ),
              ),
              TextInput(
                label: 'Full Name',
                onTextChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validate: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextInput(
                hint: 'example@gmail.com',
                label: 'Email',
                onTextChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validate: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              PasswordInput(
                text: "Password",
                validate: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (value.length < 6) {
                    return 'Password is too small';
                  }
                  return null;
                },
                onPasswordChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              PasswordInput(
                text: "Confirm password",
                validate: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (value != password) {
                    return "Confirm password doesn't match with password";
                  }
                  return null;
                },
                onPasswordChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 2),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String? res = await _auth.signUpWithEmailAndPassword(email, password, name);
                      if (res != null) {
                        setState(() {
                          message = res;
                        });
                      }
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(const Size.fromHeight(60)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(const Color.fromARGB(255, 193, 54, 86)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double>(0),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 16, height: 1), // up text bit
                  ),
                ),
              ),
              TextButton(
                child: const Text("Already have an acount?"),
                onPressed: () {
                  widget.toggleView();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
