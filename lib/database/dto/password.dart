class Password {
  int? id;
  String name;
  String password;
  DateTime createdIn = DateTime.now();
  DateTime updatedIn = DateTime.now();

  Password({required this.password, this.id, required this.name});

  static Password fromJson(Map<dynamic, dynamic> json) {
    return Password(password: json['password'], id: json['id'], name: json['name']);
  }
}
