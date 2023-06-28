import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_senhas/database/dto/credentials.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';
import 'package:gerador_senhas/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PasswordDao passwordDao = PasswordDao();
  Future<List<Credentials>>? _futurePasswordList;

  @override
  void initState() {
    super.initState();
    _futurePasswordList = passwordDao.readAll();
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
                title: Text(AppLocalizations.of(context)!.settings), trailing: const Icon(Icons.settings)),
          ),
          const Divider(),
          MaterialButton(
            onPressed: () => Navigator.pushNamed(context, Routes.about),
            padding: EdgeInsets.zero,
            child: ListTile(
                title: Text(AppLocalizations.of(context)!.about), trailing: const Icon(Icons.arrow_forward)),
          ),
          const Divider(),
        ]),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        actions: [
          IconButton(onPressed: () => Navigator.pushNamed(context, "/test"), icon: Icon(Icons.password))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        onPressed: () {
          Navigator.pushNamed(context, Routes.createPassword)
              .then((value) async => setState(() {
                    _futurePasswordList = passwordDao.readAll();
                  }));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _futurePasswordList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Credentials> passwordList = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: passwordList.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        AppLocalizations.of(context)!.delete,
                        style: const TextStyle(color: Colors.white),
                      )),
                  key: ValueKey<Credentials>(passwordList[index]),
                  onDismissed: (direction) {
                    setState(() {
                      passwordDao.delete(passwordList[index].id!);
                      passwordList.removeAt(index);
                    });
                  },
                  child: ListTile(
                    title: Text("${AppLocalizations.of(context)!.name}: ${passwordList[index].name}"),
                    subtitle: Text("${AppLocalizations.of(context)!.password}: "),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.editPassword,
                                    arguments: passwordList[index])
                                .then((value) => setState(() {
                                      _futurePasswordList =
                                          passwordDao.readAll();
                                    }));
                          },
                        ),
                        IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              Clipboard.setData(ClipboardData(
                                      text: "passwordList[index].password"))
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context)!.clipboard))));
                            }),
                      ],
                    ),
                  ),
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
