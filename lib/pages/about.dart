import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class About extends StatelessWidget {
  About({super.key});
  String version = "";

  teste() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    teste();
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.aboutApp)),
      body: Column(
        children: [
          Text(AppLocalizations.of(context)!.appDescription),
          ListTile(title: Text(AppLocalizations.of(context)!.version), trailing: Text(version),),
        ],
      ),
    );
  }
}
