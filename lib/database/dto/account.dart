import 'package:gerador_senhas/database/dto/credentials.dart';
import 'package:gerador_senhas/database/dto/social_media.dart';
import 'package:gerador_senhas/util/util.dart';

class Account {
  final int? id;
  final String name;
  final SocialMedia? socialMedia;
  List<Credentials> credentials;
  final DateTime createdIn = DateTime.now();
  final DateTime updatedIn = DateTime.now();

  Account({this.id, this.socialMedia, required this.name, required this.credentials});

  static Account fromJson(Map<dynamic, dynamic> json) {
    return Account(
      id: json['id'],
      socialMedia: Util.socialMediaList.firstWhere((element) => element.name == json['social_media']),
      name: json['name'],
      credentials: json['credentials'] ?? [],
    );
  }
}
