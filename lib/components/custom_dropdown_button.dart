import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final String Function(T?)? validator;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final String labelText;
  final T? value;

  const CustomDropdownButton(
      {super.key,
      this.validator,
      this.value,
      required this.items,
      required this.onChanged,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      validator: validator,
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText),
      menuMaxHeight: 200,
    );
  }
}
