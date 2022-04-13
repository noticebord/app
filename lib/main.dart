import 'package:app/application_model.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const noticebordBrandColor = Color.fromRGBO(104, 117, 245, 1);
final noticebordMaterialColor = createMaterialColor(noticebordBrandColor);

class Auth {
  final String? token;
  final int? user;

  const Auth(this.token, this.user);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoticebordApp());
}

Future<Auth> loadAuth() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final user = prefs.getInt('user');
  return Auth(token, user);
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;
  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
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
        theme: ThemeData(
          primarySwatch: noticebordMaterialColor,
          textTheme: GoogleFonts.nunitoTextTheme(),
        ),
        debugShowCheckedModeBanner: false, //For development purposes
        home: FutureBuilder<Auth>(
            future: loadAuth(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              final auth = snapshot.data!;
              final app = Provider.of<ApplicationModel>(context, listen: false);
              Future.delayed(Duration.zero, () {
                if (auth.token != null && auth.user != null) {
                  app.setAuth(auth.token!, auth.user!);
                }
              });
              return snapshot.hasData
                  ? const HomePage(title: "Noticebord")
                  : const LoginPage();
            }),
      ),
    );
  }
}
