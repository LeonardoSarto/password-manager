
class Account {
  final int? id;
  String? login;
  String? password;
  final DateTime createdIn = DateTime.now();
  final DateTime updatedIn = DateTime.now();

  Account({this.password, this.id, this.login});

  static Account fromJson(Map<dynamic, dynamic> json) {
    return Account(
        password: json['password'], id: json['id'], login: json['login']);
  }

  @override
  String toString() {
    return 'Account{id: $id, login: $login, password: $password, createdIn: $createdIn, updatedIn: $updatedIn}';
  }
}
