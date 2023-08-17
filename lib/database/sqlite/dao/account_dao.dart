import 'package:gerador_senhas/database/dto/account.dart';
import 'package:gerador_senhas/database/interface/generic_dao.dart';
import 'package:gerador_senhas/database/sqlite/connection.dart';
import 'package:gerador_senhas/database/sqlite/dao/credentials_dao.dart';
import 'package:sqflite/sqflite.dart';

class AccountDao extends GenericDao<Account, int> {

  @override
  Future<bool> delete(id) async {
    Database db = await Connection.create();
    var sql = 'DELETE FROM account WHERE id = ?';
    int linhasAfetadas = await db.rawDelete(sql, [id]);
    return linhasAfetadas > 0;
  }

  @override
  Future<Account> read(int id) async {
    Database db = await Connection.create();
    List<Map> maps = await db.query('account', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) {
      throw Exception('Not found');
    }
    Map<dynamic, dynamic> result = maps.first;
    return Account.fromJson(result);
  }

  @override
  Future<List<Account>> readAll() async {
    Database db = await Connection.create();
    List<Account> accountList = (await db.query("account")).map<Account>(Account.fromJson).toList();
    var credentialsDao = CredentialsDao();
    for(var account in accountList) {
      account.credentials = await credentialsDao.findByAccountId(account.id!);
    }
    return accountList;
  }

  @override
  Future<Account> save(Account data) async {
    Database db = await Connection.create();
    String sql;
    sql = 'INSERT INTO account (name, social_media, created_in, updated_in) VALUES (?, ?, ?, ?)';
    int id = await db.rawInsert(sql, [data.name, data.socialMedia!.name, data.createdIn.toString(), data.updatedIn.toString()]);
    data = Account(id: id, name: data.name, socialMedia: data.socialMedia, credentials: []);
    return data;
  }

  @override
  Future<int> update(Account data) async {
    try{
      if(data.id == null) {
        throw Exception("Not found");
      }
      Database db = await Connection.create();
      var sql = 'UPDATE account SET name = ?, social_media = ? WHERE id = ?';
      int id = await db.rawUpdate(sql, [ data.name, data.socialMedia!.name, data.id]);
      return id;
    } catch(e) {
      rethrow;
    }
  }

}