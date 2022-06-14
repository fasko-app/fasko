import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {Key? key,
      this.hint,
      required this.label,
      this.controller,
      required this.onTextChanged,
      required this.validate})
      : super(key: key);

  final void Function(String) onTextChanged;
  final String? Function(String?) validate;
  final String? hint;
  final String label;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: hint,
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromARGB(255, 224, 224, 224))),
        ),
        validator: validate,
        onChanged: onTextChanged,
      ),
    );
  }
}
