import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput(
      {Key? key,
      this.controller,
      this.onPasswordChanged,
      required this.text,
      required this.validate})
      : super(key: key);

  final void Function(String)? onPasswordChanged;
  final String? Function(String?) validate;
  final String text;
  final TextEditingController? controller;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isPasswordInvisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: TextFormField(
        controller: widget.controller,
        obscureText: isPasswordInvisible,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          labelText: widget.text,
          suffixIcon: IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            icon: isPasswordInvisible
                ? const Icon(Icons.remove_red_eye_outlined)
                : const Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                isPasswordInvisible = !isPasswordInvisible;
              });
            },
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromARGB(255, 224, 224, 224))),
        ),
        validator: widget.validate,
        onChanged: widget.onPasswordChanged,
      ),
    );
  }
}
