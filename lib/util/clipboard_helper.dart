import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClipboardHelper {
  ClipboardHelper._();

  static copy(String value, BuildContext context) {
    Clipboard.setData(
      ClipboardData(text: value),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.clipboard))
    );
  }

  static Future<String> paste() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    return clipboardData?.text ?? '';
  }

  static Future<bool> hasData() async => Clipboard.hasStrings();
}