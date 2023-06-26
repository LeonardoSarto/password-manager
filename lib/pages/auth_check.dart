import 'package:flutter/material.dart';
import 'package:gerador_senhas/routes/routes.dart';
import 'package:gerador_senhas/services/local_auth_service.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final ValueNotifier<bool> isLocalAuthFailed = ValueNotifier(false);

  checkLocalAuth() async {
    final auth = context.read<LocalAuthService>();
    final isLocalAuthAvailable = await auth.isBiometricAvailable();
    isLocalAuthFailed.value = false;

    if (isLocalAuthAvailable) {
      final authenticated = await auth.authenticate();

      if (!authenticated) {
        isLocalAuthFailed.value = true;
      } else {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(Routes.home);
      }
    }
  }

  @override
  void initState() {
    checkLocalAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
          valueListenable: isLocalAuthFailed,
          builder: (context, failed, _) {
            if (failed) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.jpeg"),
                  ElevatedButton(
                      child: const Text("Try again"),
                    onPressed: () {
                      checkLocalAuth();
                    }),
                ],
              );
            }
            return Center(
              child: Image.asset("assets/images/logo.jpeg"),
            );
          }),
    );
  }
}
