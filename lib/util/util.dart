import 'dart:math';

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
}