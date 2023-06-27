import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gerador_senhas/models/model_theme.dart';
import 'package:gerador_senhas/providers/providers.dart';
import 'package:gerador_senhas/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("en"),
              Locale("pt", "BR"),
            ],
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: themeNotifier.isSystem ? ThemeMode.system : themeNotifier.isDark ? ThemeMode.system : ThemeMode.light,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            initialRoute: Routes.authCheck,
            routes: Routes.list,
          );
        },
      ),
    );
  }
}
