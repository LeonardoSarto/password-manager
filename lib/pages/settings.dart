import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {
              },
              child: ListTile(
                title: Text("App theme"),
                // subtitle: Text(themeNotifier.isDark
                //     ? "Modo escuro"
                //     : themeNotifier.isSystem
                //         ? "Definido pelo sistema"
                //         : "Modo claro"),
              ),
            ),
            MaterialButton(
              onPressed: () async {
              },
              child: ListTile(
                title: Text("Notificações"),
                subtitle: Text(
                    "Você receberá notificações sobre novas atualizações e correções de bugs"),
                trailing: Switch(
                    onChanged: (value) {},
                    value: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
