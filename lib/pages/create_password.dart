import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_senhas/database/dto/password.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';
import 'package:gerador_senhas/util/util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.newPassword)),
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
                    return AppLocalizations.of(context)!.select;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.option),
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
                      return AppLocalizations.of(context)!.insertName;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.nameRegistration),
                ),
              ),
              if (dropdownValue == "Enter an existing password") ...[
                const Spacer(),
                Flexible(
                  flex: 5,
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(), labelText: AppLocalizations.of(context)!.password),
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
                        return AppLocalizations.of(context)!.insertLength;
                      }
                      if (int.parse(value) < 8) {
                        return AppLocalizations.of(context)!.shortPassword;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.length),
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
                        content: Text("${AppLocalizations.of(context)!.displayPassword} $password"),
                        action: SnackBarAction(
                            label: AppLocalizations.of(context)!.copy,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: password));
                            }),
                      ));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.register)),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
