import 'package:app/application_model.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/client/requests/authenticate_request.dart';
import 'package:app/helpers/device_helpers.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/widgets/loading_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future tryLogin() async {
    setState(() => loading = true);
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email cannot be empty")),
      );
      setState(() => loading = false);
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password cannot be empty")),
      );
      setState(() => loading = false);
      return;
    }

    try {
      final app = Provider.of<ApplicationModel>(context, listen: false);
      final request = AuthenticateRequest(
        email.trim(),
        password.trim(),
        "Noticebord App on ${await DeviceHelpers.deviceName}",
      );
      final token = await NoticebordClient.getToken(
        request,
        baseUrl: "https://noticebord.herokuapp.com/api",
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      app.setToken(token);
      setState(() => loading = false);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      setState(() => loading = false);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(title: "Noticebord"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Email address',
                  icon: Icon(Icons.person, color: primaryColor),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  icon: Icon(Icons.lock, color: primaryColor),
                ),
              ),
              const SizedBox(height: 16.0),
              LoadingButtonWidget(
                loading: loading,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Log In',
                  ),
                ),
                onPressed: () async => await tryLogin(),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: loading
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomePage(title: "Noticebord"),
                          ),
                        );
                      },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Skip for Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
