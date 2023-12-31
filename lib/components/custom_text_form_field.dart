import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;

  const CustomTextFormField(
      {super.key,
      this.controller,
      required this.labelText,
      this.validator,
      this.focusNode,
      this.onChanged,
      this.keyboardType,
      this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      focusNode: focusNode,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
