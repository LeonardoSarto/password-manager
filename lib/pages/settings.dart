import 'package:flutter/material.dart';
import 'package:gerador_senhas/components/alert-dialog/change_theme.dart';
import 'package:gerador_senhas/models/model_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, _) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                children: [
                  MaterialButton(
                    onPressed: () => showDialog(context: context, builder: (context) => const ChangeTheme()),
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.appTheme),
                      subtitle: Text(themeNotifier.isDark
                          ? AppLocalizations.of(context)!.dark
                          : themeNotifier.isSystem
                          ? AppLocalizations.of(context)!.system
                          : AppLocalizations.of(context)!.light),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
