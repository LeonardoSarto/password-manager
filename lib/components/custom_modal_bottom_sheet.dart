import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gerador_senhas/database/dto/account.dart';
import 'package:gerador_senhas/database/sqlite/dao/account_dao.dart';
import 'package:gerador_senhas/database/sqlite/dao/credentials_dao.dart';
import 'package:gerador_senhas/routes/routes.dart';

class CustomModalBottomSheet extends StatelessWidget {
  CustomModalBottomSheet({super.key, required this.account});

  final accountDao = AccountDao();
  final credentialsDao = CredentialsDao();
  final Account account;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MaterialButton(
          child: const ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit"),
          ),
          onPressed: () => Navigator.pushNamed(context, Routes.editAccount, arguments: account),
        ),
        MaterialButton(
          child: ListTile(
            leading: const Icon(Icons.delete),
            title: Text(AppLocalizations.of(context)!.delete),
          ),
          onPressed: () {
            accountDao.delete(account.id!);
            for (var element in account.credentials) {
              credentialsDao.delete(element.id!);
            }
            Navigator.pop(context, true);
          },
        ),
        const Divider(),
        MaterialButton(
          child: const ListTile(
            leading: Icon(Icons.close),
            title: Text("Close"),
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
