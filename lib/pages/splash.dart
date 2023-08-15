import 'package:flutter/material.dart';
import 'package:gerador_senhas/pages/auth_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'introduction.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  Future<Widget> checkFirstSeen() async {
    var prefs = await SharedPreferences.getInstance();
    var seen = (prefs.getBool('seen') ?? false);

    if (!seen) {
      await prefs.setBool('seen', true);
      return const Introduction();
    }
    return AuthCheck();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return snapshot.data!;
          }
        });
  }
}
