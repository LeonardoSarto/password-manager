import 'package:gerador_senhas/database/dto/credentials.dart';
import 'package:gerador_senhas/database/interface/generic_dao.dart';
import 'package:gerador_senhas/database/sqlite/connection.dart';
import 'package:sqflite/sqflite.dart';

class CredentialsDao extends GenericDao<Credentials, int> {

  @override
  Future<bool> delete(id) async {
    Database db = await Connection.create();
    var sql = 'DELETE FROM credentials WHERE id = ?';
    int linhasAfetadas = await db.rawDelete(sql, [id]);
    return linhasAfetadas > 0;
  }

  @override
  Future<Credentials> read(int id) async {
    Database db = await Connection.create();
    List<Map> maps = await db.query('credentials', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) {
      throw Exception('Not found');
    }
    Map<dynamic, dynamic> result = maps.first;
    return Credentials.fromJson(result);
  }

  @override
  Future<List<Credentials>> readAll() async {
    Database db = await Connection.create();
    List<Credentials> listaAlunos = (await db.query("credentials")).map<Credentials>(Credentials.fromJson).toList();
    return listaAlunos;
  }

  @override
  Future<Credentials> save(Credentials data) async {
    Database db = await Connection.create();
    String sql;
    sql = 'INSERT INTO credentials (password, login, account_id, created_in, updated_in) VALUES (?, ?, ?, ?, ?)';
    int id = await db.rawInsert(sql, [data.password, data.login, data.accountId, data.createdIn.toString(), data.updatedIn.toString()]);
    data = Credentials(id: id, password: data.password, login: data.login);
    return data;
  }

  @override
  Future<int> update(Credentials data) async {
    try{
      if(data.id == null) {
        throw Exception("Not found");
      }
      Database db = await Connection.create();
      var sql = 'UPDATE credentials SET password = ?, login = ?, updated_in = ? WHERE id = ?';
      int id = await db.rawUpdate(sql, [data.password, data.login, data.updatedIn.toString(), data.id]);
      return id;
    } catch(e) {
      rethrow;
    }
  }

  Future<List<Credentials>> saveAll(List<Credentials> data) async {
    Database db = await Connection.create();
    String sql;
    sql = 'INSERT INTO credentials (password, login) VALUES (?, ?)';
    for (var element in data) {
      int id = await db.rawInsert(sql, [element.password, element.login]);
      element = Credentials(id: id, password: element.password, login: element.login);
    }
    return data;
  }

  Future<List<Credentials>> findByAccountId(int id) async {
    Database db = await Connection.create();
    List<Credentials> listaAlunos = (await db.query("credentials", where: 'account_id = ?', whereArgs: [id])).map<Credentials>(Credentials.fromJson).toList();
    if (listaAlunos.isEmpty) {
      throw Exception('Not found');
    }
    return listaAlunos;
  }

}