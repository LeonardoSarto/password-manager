import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_senhas/database/dto/password.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PasswordDao passwordDao = PasswordDao();
  Future<List<Password>>? _futurePasswordList;

  @override
  void initState() {
    super.initState();
    _futurePasswordList = passwordDao.readAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Password manager")),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        onPressed: () {
          Navigator.pushNamed(context, "/create-password")
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
            return ReorderableListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              footer: const Divider(),
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
                  key: Key('$index'),
                  onDismissed: (direction) {
                    setState(() {
                      passwordDao.delete(passwordList[index].id!);
                    });
                  },
                  child: ListTile(
                    title: Text("Name: ${passwordList[index].name}"),
                    subtitle: Text("Password: ${passwordList[index].password}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                      text: passwordList[index].password))
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Copied to your clipboard !'))));
                            }),
                      ],
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Password item = passwordList.removeAt(oldIndex);
                  passwordList.insert(newIndex, item);
                });
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
