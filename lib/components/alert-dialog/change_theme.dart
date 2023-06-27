import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/model_theme.dart';

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, _) {
          return AlertDialog(
            title: const Text("App theme"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioMenuButton(
                    value: themeNotifier.isDark,
                    groupValue: true,
                    onChanged: (value) {
                      themeNotifier.isDark = true;
                    },
                    child: const Text("Dark theme")),
                RadioMenuButton(
                    value: themeNotifier.isDark ^ themeNotifier.isSystem,
                    groupValue: false,
                    onChanged: (value) {
                      themeNotifier.isDark = false;
                    },
                    child: const Text("Light theme")),
                RadioMenuButton(
                    value: themeNotifier.isSystem,
                    groupValue: true,
                    onChanged: (value) {
                      themeNotifier.isSystem = true;
                    },
                    child: const Text("System")),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
            ],
          );
        });
  }
}