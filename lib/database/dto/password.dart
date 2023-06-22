class Password {
  int? id;
  String password;
  DateTime createdIn = DateTime.now();
  DateTime updatedIn = DateTime.now();

  Password({required this.password, this.id});

  static Password fromJson(Map<dynamic, dynamic> json) {
    return Password(password: json['password'], id: json['id']);
  }
}
