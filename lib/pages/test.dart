import 'package:flutter/material.dart';
import 'package:gerador_senhas/database/dto/social_media.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  var baseUrl = "http://www.google.com/s2/favicons?sz=64&domain=";
  var socialMediaList = [
    const SocialMedia("Facebook", "facebook.com"),
    const SocialMedia("Whatsapp", "web.whatsapp.com"),
    const SocialMedia("Instagram", "instagram.com"),
    const SocialMedia("Gmail", "gmail.com")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DropdownButton<SocialMedia>(
        onChanged: (SocialMedia? value) {
          setState(() {});
        },
        items: socialMediaList
            .map((SocialMedia e) => DropdownMenuItem<SocialMedia>(
                  value: e,
                  child: Row(
                    children: [
                      Image.network("$baseUrl${e.url}"),
                      Text(e.name),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
