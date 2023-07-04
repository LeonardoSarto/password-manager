import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/model_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, _) {
          var isDark = themeNotifier.isDark;
          var isSystem = themeNotifier.isSystem;

          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.appTheme),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioMenuButton(
                    value: true,
                    groupValue: isDark,
                    onChanged: (value) {
                      isDark = true;
                      isSystem = false;
                    },
                    child: Text(AppLocalizations.of(context)!.dark)),
                RadioMenuButton(
                    value: false,
                    groupValue: isDark,
                    onChanged: (value) {
                      isDark = false;
                      isSystem = false;
                    },
                    child: Text(AppLocalizations.of(context)!.light)),
                RadioMenuButton(
                    value: true,
                    groupValue: isSystem,
                    onChanged: (value) {
                      print(isSystem);
                      isSystem = true;
                      isDark = false;
                    },
                    child: Text(AppLocalizations.of(context)!.system)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    print(isSystem);
                    print(isDark);
                    themeNotifier.isDark = isDark;
                    themeNotifier.isSystem = isSystem;
                    Navigator.pop(context);
                  },
                  child: const Text("Ok")),
            ],
          );
        });
  }
}