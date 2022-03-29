import 'package:app/application_model.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // clearToken(); // For development purposes
  runApp(const NoticebordApp());
}

clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

Future<String?> loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class NoticebordApp extends StatelessWidget {
  const NoticebordApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationModel(),
      child: MaterialApp(
        title: 'Noticebord',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: FutureBuilder<String?>(
            future: loadToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              final app = Provider.of<ApplicationModel>(context, listen: false);
              app.setToken(snapshot.data);
              return snapshot.hasData
                  ? const HomePage(title: "Noticebord")
                  : const LoginPage();
            }),
      ),
    );
  }
}