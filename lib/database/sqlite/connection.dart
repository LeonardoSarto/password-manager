import 'package:gerador_senhas/database/sqlite/script_bd.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Connection {
  static late Database _database;
  static bool _fechado = true;

  static Future<Database> create() async {
    if(_fechado){
      String path = join(await getDatabasesPath(), 'banco.db');
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, v){
          db.execute(ScriptBd.createTablePassword);
        },
      );
      _fechado = false;
    }
    return _database;
  }
}