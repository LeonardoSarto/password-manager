import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_senhas/components/custom_dropdown_button.dart';
import 'package:gerador_senhas/components/custom_text_form_field.dart';
import 'package:gerador_senhas/database/dto/account.dart';
import 'package:gerador_senhas/database/dto/credentials.dart';
import 'package:gerador_senhas/database/dto/social_media.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';
import 'package:gerador_senhas/pages/test.dart';
import 'package:gerador_senhas/util/util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  TextEditingController name = TextEditingController();
  TextEditingController login = TextEditingController();
  TextEditingController socialMedia = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var baseUrl = "http://www.google.com/s2/favicons?sz=32&domain=";
  List<Account> accountList = [Account()];

  String? _next() {
    if (_formKey.currentState!.validate()) {
      PasswordDao passwordDao = PasswordDao();
      Credentials registerPassword;

      if (password.value.text != "") {
        registerPassword = Credentials(
            socialMedia: SocialMedia(name.value.text, name.value.text));
      } else {
        registerPassword = Credentials(
            socialMedia: SocialMedia(name.value.text, name.value.text));
      }
      passwordDao.save(registerPassword);
      return "teste";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    accountList.first.login = login.text;
    accountList.first.password = password.text;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.newPassword)),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: ListView(
            children: [
              CustomDropdownButton<SocialMedia>(
                labelText: AppLocalizations.of(context)!.socialMedia,
                onChanged: (SocialMedia? value) {
                  setState(() {
                    if (value != null) {
                      socialMedia.text = value.name;
                      name.text = value.name;
                    }
                  });
                },
                items: Util.socialMediaList
                    .map((SocialMedia e) => DropdownMenuItem<SocialMedia>(
                          value: e,
                          child: Row(
                            children: [
                              Image.network(
                                "$baseUrl${e.url}",
                              ),
                              Text(e.name),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              CustomTextFormField(
                controller: name,
                labelText: AppLocalizations.of(context)!.name,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterName;
                  }
                  return null;
                },
              ),
              ListView.builder(
                itemCount: accountList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          const Flexible(
                            flex: 2,
                            child: Text("Account"),
                          ),
                          const Spacer(flex: 6),
                          IconButton(
                              onPressed: () => setState(() {
                                    if (accountList.length > 1) {
                                      accountList.removeAt(index);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("At least 1 account"),
                                      ));
                                    }
                                  }),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () => setState(() {
                                    accountList.add(Account(
                                        login: login.text,
                                        password: password.text));
                                  }),
                              icon: const Icon(
                                Icons.add,
                              )),
                        ],
                      ),
                      CustomTextFormField(
                        controller: login,
                        labelText: AppLocalizations.of(context)!.login,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.enterLogin;
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: password,
                        labelText: AppLocalizations.of(context)!.password,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.enterPassword;
                          }
                          if (value.length < 8) {
                            return AppLocalizations.of(context)!.shortPassword;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FilledButton(
                  onPressed: () {
                    String? password = _next();
                    if (password != null) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "${AppLocalizations.of(context)!.displayPassword} $password"),
                        action: SnackBarAction(
                            label: AppLocalizations.of(context)!.copy,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: password));
                            }),
                      ));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.register)),
            ],
          ),
        ),
      ),
    );
  }
}
