import 'package:flutter/material.dart';
import 'package:gerador_senhas/database/dto/password.dart';
import 'package:gerador_senhas/database/sqlite/dao/password_dao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PasswordDao passwordDao = PasswordDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Password manager")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/create-password");
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: passwordDao.readAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Password> passwordList = snapshot.data!;
            return Text(passwordList[0].password);
          } else {
            return const Center(child: Text("Not found any passwords"));
          }
        },
      ),
    );
  }
}
