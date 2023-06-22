import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerador_senhas/database/dto/password.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  List<String> list = <String>[
    'Create new password',
    'Enter an existing password'
  ];
  TextEditingController passwordName = TextEditingController();
  TextEditingController passwordLength = TextEditingController();
  TextEditingController password = TextEditingController();
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();

  String? _next() {
    if (_formKey.currentState!.validate()) {
      PasswordDao passwordDao = PasswordDao();
      Password registerPassword;

      if (password.value.text != "") {
        registerPassword = Password(password: password.value.text);
      } else {
        String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String lower = 'abcdefghijklmnopqrstuvwxyz';
        String numbers = '1234567890';
        String symbols = '!@#\$%^&*()<>,./';
        int passLength = int.parse(passwordLength.value.text);
        String seed = upper + lower + numbers + symbols;
        String password = '';
        List<String> list = seed.split('').toList();
        Random rand = Random();

        for (int i = 0; i < passLength; i++) {
          int index = rand.nextInt(list.length);
          password += list[index];
        }
        registerPassword = Password(password: password);
      }
      passwordDao.save(registerPassword);
      return registerPassword.password;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Create password")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Spacer(),
            const Text("What do you want?"),
            const Spacer(),
            Flexible(
              flex: 4,
              child: DropdownButtonFormField(
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "Select what do you want";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Select an option"),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 5,
              child: TextFormField(
                controller: passwordName,
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "Insert a name to the password";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name the password"),
              ),
            ),
            if (dropdownValue == "Enter an existing password") ...[
              const Spacer(),
              Flexible(
                flex: 5,
                child: TextFormField(
                  controller: password,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                ),
              ),
            ],
            if (dropdownValue == "Create new password") ...[
              const Spacer(),
              Flexible(
                flex: 5,
                child: TextFormField(
                  controller: passwordLength,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Insert a password length";
                    }
                    if(int.parse(value) < 8) {
                      return "Your password is too short!";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password length"),
                ),
              ),
            ],
            const Spacer(),
            FilledButton(
                onPressed: () {
                  String? password = _next();

                  if(password != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text("Password registered!"),
                            content: Text("Your password is $password"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                  }
                },
                child: const Text("Register password")),
          ],
        ),
      ),
    );
  }
}
