import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_senhas/database/dto/password.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';
import 'package:gerador_senhas/routes/routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PasswordDao passwordDao = PasswordDao();
  Future<List<Password>>? _futurePasswordList;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _futurePasswordList = passwordDao.readAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Image.asset("assets/images/logo.jpeg")),
            const ListTile(title: Text("Settings"), trailing: Icon(Icons.settings)),
            const Divider(),
            const ListTile(title: Text("About"), trailing: Icon(Icons.arrow_forward)),
            const Divider(),
          ]
        ),
      ),
      appBar: AppBar(
        title: const Text("Password manager"),
        actions: [
          IconButton(
              icon:
                  Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              }),
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
            List<Password> passwordList = snapshot.data!;
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
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      )),
                  key: ValueKey<Password>(passwordList[index]),
                  onDismissed: (direction) {
                    setState(() {
                      passwordDao.delete(passwordList[index].id!);
                      passwordList.removeAt(index);
                    });
                  },
                  child: ListTile(
                    title: Text("Name: ${passwordList[index].name}"),
                    subtitle: Text(
                        "Password: ${showPassword ? passwordList[index].password : ("*" * passwordList[index].password.length)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.editPassword, arguments: passwordList[index]).then((value) => setState((){_futurePasswordList = passwordDao.readAll();}));
                          },
                        ),
                        IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              if (showPassword) {
                                Clipboard.setData(ClipboardData(
                                        text: passwordList[index].password))
                                    .then((value) => ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Copied to your clipboard !'))));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Show your passwords first!')));
                              }
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Not found any passwords"));
          }
        },
      ),
    );
  }
}
