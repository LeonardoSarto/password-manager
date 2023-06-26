import 'package:flutter/material.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';

import '../database/dto/password.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final passwordField = TextFormField(
    decoration: const InputDecoration(
        border: OutlineInputBorder(), labelText: "Password"),
    controller: TextEditingController(),
  );
  final nameField = TextFormField(
    decoration:
        const InputDecoration(border: OutlineInputBorder(), labelText: "Name"),
    controller: TextEditingController(),
  );
  final textError = const Center(child: Text("Credentials not found"));
  late Password credentials;
  PasswordDao passwordDao = PasswordDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getValueByArguments(context)
          ? Column(
              children: [
                const Spacer(),
                Flexible(child: nameField),
                const Spacer(),
                Flexible(child: passwordField),
                const Spacer(),
                FilledButton(
                    child: const Text("Save"),
                    onPressed: () {
                      Password editCredentials = Password(
                          password: passwordField.controller!.text,
                          name: nameField.controller!.text,
                          id: credentials.id);
                      passwordDao.update(editCredentials);
                      Navigator.pop(context);
                    }),
              ],
            )
          : textError,
    );
  }

  bool getValueByArguments(BuildContext context) {
    var argument = ModalRoute.of(context);
    if (argument != null) {
      credentials = argument.settings.arguments as Password;
      fillFields(credentials);
      return true;
    }

    return false;
  }

  fillFields(Password credentials) {
    nameField.controller?.text = credentials.name;
    passwordField.controller?.text = credentials.password;
  }
}
