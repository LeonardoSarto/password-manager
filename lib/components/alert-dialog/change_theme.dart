import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/model_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({super.key});

  @override
  State<ChangeTheme> createState() => _ChangeTheme();
}

class _ChangeTheme extends State<ChangeTheme> {


  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, _) {

          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.appTheme),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioMenuButton(
                    value: true,
                    groupValue: themeNotifier.isDark,
                    onChanged: (value) {
                      setState(() {
                        themeNotifier.isDark = true;
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.dark)),
                RadioMenuButton(
                    value: true,
                    groupValue: !themeNotifier.isDark && !themeNotifier.isSystem,
                    onChanged: (value) {
                      setState(() {
                        print("teste");
                        themeNotifier.isDark = false;
                        themeNotifier.isSystem = false;
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.light)),
                RadioMenuButton(
                    value: true,
                    groupValue: themeNotifier.isSystem,
                    onChanged: (value) {
                      setState(() {
                        themeNotifier.isSystem = true;
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.system)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Ok")),
            ],
          );
        });
  }
}
