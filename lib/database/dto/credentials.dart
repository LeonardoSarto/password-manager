
class Credentials {
  final int? id;
  String? login;
  String? password;
  bool showPassword = false;
  int? accountId;
  final DateTime createdIn = DateTime.now();
  final DateTime updatedIn = DateTime.now();

  Credentials({this.password, this.id, this.login, this.accountId});

  static Credentials fromJson(Map<dynamic, dynamic> json) {
    return Credentials(
        password: json['password'],
        id: json['id'],
        login: json['login'],
        accountId: json['account']);
  }

  @override
  String toString() {
    return 'Credentials{id: $id, login: $login, password: $password, createdIn: $createdIn, updatedIn: $updatedIn}';
  }
}
