import 'package:flutter/material.dart';
import 'package:gerador_senhas/components/custom_dropdown_button.dart';
import 'package:gerador_senhas/components/custom_text_form_field.dart';
import 'package:gerador_senhas/database/dto/credentials.dart';
import 'package:gerador_senhas/database/dto/account.dart';
import 'package:gerador_senhas/database/dto/social_media.dart';
import 'package:gerador_senhas/database/sqlite/dao/account_dao.dart';
import 'package:gerador_senhas/database/sqlite/dao/credentials_dao.dart';
import 'package:gerador_senhas/util/util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  var name = TextEditingController();
  var socialMedia = TextEditingController();
  List<TextEditingController> login = [];
  List<TextEditingController> password = [];
  final _formKey = GlobalKey<FormState>();
  List<Credentials> credentialList = [];
  List<FocusNode> focusPasswordList = [FocusNode()];
  late Account account;

  bool getValueByArguments(BuildContext context) {
    var argument = ModalRoute.of(context);
    if (argument != null) {
      account = argument.settings.arguments as Account;
      fillFields(account);
      return true;
    }
    return false;
  }

  fillFields(Account account) {
    name.text = account.name;
    socialMedia.text = Util.socialMediaList.first.name;
    credentialList = account.credentials;
    for (var element in credentialList) {
      login.add(TextEditingController(text: element.login));
      password.add(TextEditingController(text: element.password));
      var focusNode = FocusNode();
      focusNode.addListener(whenChangeFocus);
      focusPasswordList.add(focusNode);
    }
  }

  Future<bool> _next() async {
    try {
      if (_formKey.currentState!.validate()) {
        var registerCredentials = CredentialsDao();
        var registerAccount = AccountDao();

        var account = Account(
            name: name.value.text,
            socialMedia: SocialMedia(socialMedia.value.text, ""),
            credentials: []);
        account = await registerAccount.save(account);

        for (var index = 0; index < credentialList.length; index++) {
          credentialList[index].accountId = account.id;
          credentialList[index].password = password[index].value.text;
          await registerCredentials.save(credentialList[index]);
        }
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    for (var element in focusPasswordList) {
      element.dispose();
    }
    super.dispose();
  }

  void whenChangeFocus() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValueByArguments(context);
    return Scaffold(
      bottomSheet: SizedBox(
        width: Util.displayWidth(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (focusPasswordList
                .where((element) => element.hasFocus)
                .isNotEmpty)
              TextButton.icon(
                  icon: const Icon(Icons.auto_fix_high),
                  label: Text("Generate password"),
                  onPressed: () => password[focusPasswordList.indexOf(
                          focusPasswordList
                              .firstWhere((element) => element.hasFocus))]
                      .text = Util.generatePassword(8)),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: Text("One more account"),
              onPressed: () => setState(() {
                login.add(TextEditingController());
                password.add(TextEditingController());
                credentialList.add(Credentials(
                    login: login.last.text, password: password.last.text));
                var focusNode = FocusNode();
                focusNode.addListener(whenChangeFocus);
                focusPasswordList.add(focusNode);
              }),
            ),
            FilledButton(
                onPressed: () {
                  _next().then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Success"),
                      ));
                      Navigator.pop(context);
                    }
                  });
                },
                child: Text(AppLocalizations.of(context)!.register)),
            SizedBox(height: Util.displayHeight(context) * 0.02),
          ],
        ),
      ),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.newPassword)),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: ListView(
            children: [
              SizedBox(height: Util.displayHeight(context) * 0.04),
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
                                "${Util.baseUrl}${e.url}",
                              ),
                              Text(e.name),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: Util.displayHeight(context) * 0.04),
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
              SizedBox(height: Util.displayHeight(context) * 0.04),
              ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(height: Util.displayHeight(context) * 0.01),
                itemCount: credentialList.length,
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
                                    if (credentialList.length > 1) {
                                      credentialList.removeAt(index);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("At least 1 account"),
                                      ));
                                    }
                                  }),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      SizedBox(height: Util.displayHeight(context) * 0.02),
                      SizedBox(
                        width: Util.displayWidth(context) * 0.8,
                        child: CustomTextFormField(
                          textInputAction: TextInputAction.next,
                          controller: login[index],
                          labelText: AppLocalizations.of(context)!.login,
                          onChanged: (String? value) {
                            credentialList[index].login =
                                login[index].value.text;
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.enterLogin;
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: Util.displayHeight(context) * 0.04),
                      SizedBox(
                        width: Util.displayWidth(context) * 0.8,
                        child: CustomTextFormField(
                          focusNode: focusPasswordList[index],
                          onChanged: (String? value) {
                            credentialList[index].password =
                                password[index].value.text;
                          },
                          controller: password[index],
                          labelText: AppLocalizations.of(context)!.password,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .enterPassword;
                            }
                            if (value.length < 8) {
                              return AppLocalizations.of(context)!
                                  .shortPassword;
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: Util.displayHeight(context) * 0.04),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Util.displayHeight(context) * 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
