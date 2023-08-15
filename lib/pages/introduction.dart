import 'package:flutter/material.dart';
import 'package:gerador_senhas/routes/routes.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        showDoneButton: true,
        showNextButton: true,
        showBackButton: false,
        showBottomPart: true,
        showSkipButton: true,
        next: Text(AppLocalizations.of(context)!.next),
        skip: Text(AppLocalizations.of(context)!.skip),
        done: Text(AppLocalizations.of(context)!.done),
        onDone: () => Navigator.pushNamed(context, Routes.authCheck),
        dotsDecorator: DotsDecorator(
            activeColor: Theme.of(context).buttonTheme.colorScheme!.primary,
            color: Theme.of(context).colorScheme.secondary
        ),
        bodyPadding: const EdgeInsets.only(top: 150),
        pages: [
          PageViewModel(
            title: AppLocalizations.of(context)!.appIntroductionTitle,
            body: AppLocalizations.of(context)!.appIntroduction,
            image: Image.asset("assets/images/Security_On-pana.png"),
          ),
          PageViewModel(
            title: AppLocalizations.of(context)!.appPasswordsTitle,
            body: AppLocalizations.of(context)!.appPasswords,
            image: Image.asset("assets/images/Login-cuate.png"),
          ),
          PageViewModel(
            title: AppLocalizations.of(context)!.appBiometryTitle,
            body: AppLocalizations.of(context)!.appBiometry,
            image: Image.asset("assets/images/Fingerprint-rafiki.png"),
          ),
          PageViewModel(
            title: AppLocalizations.of(context)!.appSecurityTitle,
            body: AppLocalizations.of(context)!.appSecurity,
            image: Image.asset("assets/images/Security_On-bro.png"),
          ),
        ],
      ),
    );
  }
}
