import 'package:app/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const NoticebordApp());
}

class NoticebordApp extends StatelessWidget {
  const NoticebordApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noticebord',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

