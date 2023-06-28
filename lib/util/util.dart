import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerador_senhas/database/dto/social_media.dart';


class Util {
  static String generatePassword(int passwordLength) {
    String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lower = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '1234567890';
    String symbols = '!@#\$%^&*()<>,./';
    int passLength = passwordLength;
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

  static Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  static double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  static const baseUrl = "http://www.google.com/s2/favicons?sz=32&domain=";
}