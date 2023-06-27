import 'dart:math';

import '../pages/test.dart';

class Util {
  static String generatePassword(String passwordLength) {
    String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lower = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '1234567890';
    String symbols = '!@#\$%^&*()<>,./';
    int passLength = int.parse(passwordLength);
    String seed = upper + lower + numbers + symbols;
    String password = '';
    List<String> list = seed.split('').toList();
    Random rand = Random();

    for (int i = 0; i < passLength; i++) {
      int index = rand.nextInt(list.length);
      password += list[index];
    }

    return password;
  }

  static const socialMediaList = [
    SocialMedia("Facebook", "www.facebook.com"),
    SocialMedia("Whatsapp", "web.whatsapp.com"),
    SocialMedia("Instagram", "www.instagram.com"),
    SocialMedia("Google", "gmail.com"),
    SocialMedia("Twitter", "www.twitter.com"),
    SocialMedia("Riot Games", "www.riotgames.com"),
  ];
}