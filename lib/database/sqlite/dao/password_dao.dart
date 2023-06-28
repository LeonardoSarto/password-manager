import 'package:gerador_senhas/database/dto/credentials.dart';
import 'package:gerador_senhas/database/interface/generic_dao.dart';
import 'package:gerador_senhas/database/sqlite/connection.dart';
import 'package:sqflite/sqflite.dart';

class PasswordDao extends GenericDao<Credentials, int> {

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
    sql = 'INSERT INTO credentials (password, name, login, social_media) VALUES (?, ?, ?, ?)';
    int id = await db.rawInsert(sql, [data.name, data.socialMedia]);
    data = Credentials(id: id, name: data.name);
    return data;
  }

  @override
  Future<int> update(Credentials data) async {
    try{
      if(data.id == null) {
        throw Exception("Not found");
      }
      Database db = await Connection.create();
      var sql = 'UPDATE password SET credentials = ?, name = ? WHERE id = ?';
      int id = await db.rawUpdate(sql, [ data.name, data.id]);
      return id;
    } catch(e) {
      rethrow;
    }
  }

}