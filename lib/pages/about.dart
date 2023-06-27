import 'package:flutter/material.dart';
import 'package:gerador_senhas/components/alert-dialog/change_theme.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () => showDialog(context: context, builder: (context) => const ChangeTheme()),
              child: const ListTile(
                title: Text("App theme"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
