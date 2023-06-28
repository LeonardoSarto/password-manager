import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextFormField(
      {super.key,
      this.controller,
      required this.labelText,
      this.validator,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText),
        validator: validator,
        keyboardType: keyboardType,
    );
  }
}
