import 'package:flutter/material.dart';
import 'package:gerador_senhas/components/alert-dialog/change_theme.dart';
import 'package:gerador_senhas/pages/about.dart';
import 'package:gerador_senhas/pages/auth_check.dart';
import 'package:gerador_senhas/pages/create_password.dart';
import 'package:gerador_senhas/pages/edit_account.dart';
import 'package:gerador_senhas/pages/home.dart';
import 'package:gerador_senhas/pages/introduction.dart';
import 'package:gerador_senhas/pages/settings.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    "/home": (_) => const Home(),
    "/auth_check": (_) => const AuthCheck(),
    "/create_account": (_) => const CreatePassword(),
    "/edit_account": (_) => const EditAccount(),
    "/settings": (_) => const Settings(),
    "/change_theme": (_) => const ChangeTheme(),
    "/about": (_) => About(),
    "/introduction": (_) => Introduction(),
  };

  static const String authCheck = "/auth_check";

  static const String home = "/home";

  static const String createAccount = "/create_account";

  static const String editAccount = "/edit_account";

  static const String settings = "/settings";

  static const String changeTheme = "/change_theme";

  static const String about = "/about";

  static const String intro = "/introduction";

}
