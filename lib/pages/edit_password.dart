import 'package:flutter/material.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../database/dto/password.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  passwordField(context) => TextFormField(
    decoration: InputDecoration(
        border: const OutlineInputBorder(), labelText: AppLocalizations.of(context)!.password),
    controller: TextEditingController(),
  );
  nameField(context) => TextFormField(
    decoration:
        InputDecoration(border: const OutlineInputBorder(), labelText: AppLocalizations.of(context)!.name),
    controller: TextEditingController(),
  );
  textError(context) => Center(child: Text(AppLocalizations.of(context)!.credentialsNotFound));
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
                Flexible(child: nameField(context)),
                const Spacer(),
                Flexible(child: passwordField(context)),
                const Spacer(),
                FilledButton(
                    child: Text(AppLocalizations.of(context)!.save),
                    onPressed: () {
                      Password editCredentials = Password(
                          password: passwordField(context).controller!.text,
                          name: nameField(context).controller!.text,
                          id: credentials.id);
                      passwordDao.update(editCredentials);
                      Navigator.pop(context);
                    }),
              ],
            )
          : textError(context),
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
    nameField(context).controller?.text = credentials.name;
    passwordField(context).controller?.text = credentials.password;
  }
}
