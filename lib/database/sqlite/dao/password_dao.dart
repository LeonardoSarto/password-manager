import 'package:gerador_senhas/database/dto/password.dart';
import 'package:gerador_senhas/database/interface/generic_dao.dart';
import 'package:gerador_senhas/database/sqlite/connection.dart';
import 'package:sqflite/sqflite.dart';

class PasswordDao extends GenericDao<Password, int> {

  @override
  Future<bool> delete(id) async {
    Database db = await Connection.create();
    var sql = 'DELETE FROM password WHERE id = ?';
    int linhasAfetadas = await db.rawDelete(sql, [id]);
    return linhasAfetadas > 0;
  }

  @override
  Future<Password> read(int id) async {
    Database db = await Connection.create();
    List<Map> maps = await db.query('password', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) {
      throw Exception('Not found');
    }
    Map<dynamic, dynamic> result = maps.first;
    return Password.fromJson(result);
  }

  @override
  Future<List<Password>> readAll() async {
    Database db = await Connection.create();
    List<Password> listaAlunos = (await db.query("password")).map<Password>(Password.fromJson).toList();
    return listaAlunos;
  }

  @override
  Future<Password> save(Password data) async {
    Database db = await Connection.create();
    String sql;
    sql = 'INSERT INTO password (password, name) VALUES (?, ?)';
    int id = await db.rawInsert(sql, [data.password, data.name]);
    data = Password(id: id, password: data.password, name: data.name);
    return data;
  }

  @override
  Future<int> update(Password data) async {
    try{
      if(data.id == null) {
        throw Exception("Not found");
      }
      Database db = await Connection.create();
      var sql = 'UPDATE password SET password = ?, name = ? WHERE id = ?';
      int id = await db.rawUpdate(sql, [data.password, data.name, data.id]);
      return id;
    } catch(e) {
      rethrow;
    }
  }

}