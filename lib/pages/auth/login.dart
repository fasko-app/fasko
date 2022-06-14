import 'package:fasko_mobile/services/auth.dart';
//cdimport 'package:fasko_mobile/widgets/icons.dart';
import 'package:fasko_mobile/widgets/password_input.dart';
import 'package:fasko_mobile/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:fasko_mobile/widgets/bar.dart';

class LogInPage extends StatefulWidget {
  final Function toggleView;

  const LogInPage({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool isPasswordInvisible = true;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  String error = '';

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
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              TextInput(
                hint: 'you@example.com',
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
                onPasswordChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                text: 'Password',
                validate: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String? message = await _auth.signInWithEmailAndPassword(email, password);
                      if (message != null) {
                        setState(() {
                          error = message;
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
              /*
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text(
                  'or',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: OutlinedButton.icon(
                  onPressed: null,
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 16),
                  ),
                  icon: const Icon(CustomIcons.google, color: Colors.blue),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(const Size.fromHeight(60)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(color: Colors.black))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 2),
                child: ElevatedButton.icon(
                  onPressed: null,
                  label: const Text(
                    'Sign in with GitHub',
                    style: TextStyle(fontSize: 16),
                  ),
                  icon: const Icon(CustomIcons.github, color: Colors.white),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(const Size.fromHeight(60)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(const Color.fromARGB(255, 26, 37, 59)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double>(0),
                  ),
                ),
              ),
              */
              TextButton(
                child: const Text("Don't have an acount?"),
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
