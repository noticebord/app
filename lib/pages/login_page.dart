import 'package:app/application_model.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/client/requests/authenticate_request.dart';
import 'package:app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Image.asset('assets/logo.png', width: 100, height: 100),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Address',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Log In'),
                onPressed: () async {
                  final email = emailController.text;
                  final password = passwordController.text;

                  if (email == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email address cannot be empty"),
                      ),
                    );
                    return;
                  }
                  if (password == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password cannot be empty"),
                      ),
                    );
                    return;
                  }

                  try {
                    final app =
                        Provider.of<ApplicationModel>(context, listen: false);
                    final request =
                        AuthenticateRequest(email, password, "App");
                    final token = await NoticebordClient.getToken(request);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("token", token);
                    app.setToken(token);
                  } on Exception catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                    ));
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(
                        title: "Noticebord",
                      ),
                    ),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(
                        title: "Noticebord",
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Skip for Now',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
