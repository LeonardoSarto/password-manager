import 'package:flutter/material.dart';
import 'package:gerador_senhas/pages/auth_check.dart';
import 'package:gerador_senhas/pages/create_password.dart';
import 'package:gerador_senhas/pages/home.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    "/home": (_) => const Home(),
    "/auth-check": (_) => const AuthCheck(),
    "/create-password": (_) => const CreatePassword(),
  };

  static const String authCheck = "/auth-check";

  static const String home = "/home";
}
