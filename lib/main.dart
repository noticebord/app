import 'package:app/application_model.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const noticebordBrandColor = Color.fromRGBO(104, 117, 245, 1);
final noticeBordMaterialColor = createMaterialColor(noticebordBrandColor);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoticebordApp());
}

Future<String?> loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
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
        theme: ThemeData(primarySwatch: noticeBordMaterialColor, textTheme: GoogleFonts.nunitoTextTheme()),
        debugShowCheckedModeBanner: false, //For development purposes
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
