import 'package:flutter/material.dart';
import 'package:gerador_senhas/pages/auth_check.dart';
import 'package:gerador_senhas/pages/create_password.dart';
import 'package:gerador_senhas/pages/edit_password.dart';
import 'package:gerador_senhas/pages/home.dart';
import 'package:gerador_senhas/pages/settings.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    "/home": (_) => const Home(),
    "/auth-check": (_) => const AuthCheck(),
    "/create-password": (_) => const CreatePassword(),
    "/edit-password": (_) => const EditPassword(),
    "/settings": (_) => const Settings(),
  };

  static const String authCheck = "/auth-check";

  static const String home = "/home";

  static const String createPassword = "/create-password";

  static const String editPassword = "/edit-password";

  static const String settings = "/settings";
}
