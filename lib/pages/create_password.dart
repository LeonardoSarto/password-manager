import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_senhas/database/dto/password.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';
import 'package:gerador_senhas/util/util.dart';

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
        registerPassword = Password(
            password: password.value.text, name: passwordName.value.text);
      } else {
        registerPassword = Password(
            password: Util.generatePassword(passwordLength.value.text),
            name: passwordName.value.text);
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
            Flexible(
              flex: 2,
              child: DropdownButtonFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
            if (dropdownValue != null) ...[
              const Spacer(),
              Flexible(
                flex: 5,
                child: TextFormField(
                  controller: passwordName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                      if (value == null || value.isEmpty) {
                        return "Insert a password length";
                      }
                      if (int.parse(value) < 8) {
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
                    if (password != null) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Your password is $password"),
                        action: SnackBarAction(
                            label: "Copy",
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: password));
                            }),
                      ));
                    }
                  },
                  child: const Text("Register password")),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
