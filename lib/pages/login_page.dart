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
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.blue,
                  )),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Noticebord',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Address',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
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
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
