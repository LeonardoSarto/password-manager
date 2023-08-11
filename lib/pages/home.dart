import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_senhas/components/custom_modal_bottom_sheet.dart';
import 'package:gerador_senhas/database/dto/account.dart';
import 'package:gerador_senhas/database/sqlite/dao/account_dao.dart';
import 'package:gerador_senhas/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gerador_senhas/util/clipboard_helper.dart';
import 'package:gerador_senhas/util/util.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AccountDao accountDao = AccountDao();
  Future<List<Account>>? _futureAccountList;

  @override
  void initState() {
    super.initState();
    _futureAccountList = accountDao.readAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(children: [
          DrawerHeader(child: Image.asset("assets/images/logo.jpeg")),
          MaterialButton(
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
            padding: EdgeInsets.zero,
            child: ListTile(
                title: Text(AppLocalizations.of(context)!.settings),
                trailing: const Icon(Icons.settings)),
          ),
          const Divider(),
          MaterialButton(
            onPressed: () => Navigator.pushNamed(context, Routes.about),
            padding: EdgeInsets.zero,
            child: ListTile(
                title: Text(AppLocalizations.of(context)!.about),
                trailing: const Icon(Icons.info)),
          ),
        ]),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        onPressed: () {
          Navigator.pushNamed(context, Routes.createAccount)
              .then((value) async => setState(() {
                    _futureAccountList = accountDao.readAll();
                  }));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _futureAccountList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Account> accountList = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: accountList.length,
              itemBuilder: (BuildContext context, int index) {
                var account = accountList[index];
                return ExpansionTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        "${Util.baseUrl}${account.socialMedia!.url}",
                        scale: 1,
                      ),
                      SizedBox(width: Util.displayWidth(context) * 0.02),
                      Text(account.socialMedia!.name),
                    ],
                  ),
                  subtitle: Text(account.socialMedia!.url),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        isDismissible: false,
                        enableDrag: false,
                        context: context,
                        builder: (context) =>
                            CustomModalBottomSheet(account: account),
                      ).then((value) {
                        if (value) {
                          setState(() {
                            _futureAccountList = accountDao.readAll();
                          });
                        }
                      });
                    },
                  ),
                  children: [
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: account.credentials
                          .map((e) => Card(
                        child: Column(
                          children: [
                            ListTile(
                              title:
                              Text(AppLocalizations.of(context)!.login),
                              subtitle: Text(e.login!),
                              trailing: IconButton(
                                  onPressed: () => ClipboardHelper.copy(
                                      e.login!, context),
                                  icon: const Icon(Icons.copy)),
                            ),
                            ListTile(
                              title: Text(
                                  AppLocalizations.of(context)!.password),
                              subtitle: Text(e.showPassword
                                  ? e.password!
                                  : '*' * e.password!.length),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () => setState(() {
                                        e.showPassword =
                                        !e.showPassword;
                                      }),
                                      icon: Icon(e.showPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility)),
                                  IconButton(
                                      onPressed: () => ClipboardHelper.copy(
                                          e.login!, context),
                                      icon: const Icon(Icons.copy)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text(AppLocalizations.of(context)!.notFound));
          }
        },
      ),
    );
  }
}
