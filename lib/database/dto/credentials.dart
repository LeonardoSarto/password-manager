import 'package:gerador_senhas/database/dto/social_media.dart';

class Credentials {
  final int? id;
  final SocialMedia? socialMedia;
  final String? name;
  final DateTime createdIn = DateTime.now();
  final DateTime updatedIn = DateTime.now();

  Credentials({this.id, this.socialMedia, this.name});

  static Credentials fromJson(Map<dynamic, dynamic> json) {
    return Credentials(
      id: json['id'],
      socialMedia: json['socialMedia'],
      name: json['name'],
    );
  }
}
