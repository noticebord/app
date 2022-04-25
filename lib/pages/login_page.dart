import 'package:app/application_model.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/client/requests/authenticate_request.dart';
import 'package:app/helpers/device_helpers.dart';
import 'package:app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future tryLogin() async {
    setState(() => loading = true);
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email cannot be empty')),
      );
      setState(() => loading = false);
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password cannot be empty')),
      );
      setState(() => loading = false);
      return;
    }

    try {
      // Try logging in.
      const baseUrl = 'https://noticebord.herokuapp.com/api';
      final app = Provider.of<ApplicationModel>(context, listen: false);
      final request = AuthenticateRequest(
        email.trim(),
        password.trim(),
        'Noticebord App on ${await DeviceHelpers.deviceName}',
      );

      // Get token and use it to get logged in user
      final token = await NoticebordClient.getToken(request, baseUrl: baseUrl);
      final client = NoticebordClient(token: token, baseUrl: baseUrl);
      final user = await client.users.fetchCurrentUser();

      // Done. Persist everything.
      app.setAuth(token, user.id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('user', user.id);
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
        builder: (context) => const HomePage(title: 'Noticebord'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login to your\naccount',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/accent.png', width: 99, height: 4),
                ],
              ),
              const SizedBox(height: 56),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withAlpha(30),
                        labelText: 'Email address',
                        hintText: 'user@mail.com',
                        prefixIcon: const Icon(Icons.person_pin),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withAlpha(30),
                        labelText: 'Password',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.shield),
                        suffixIcon: IconButton(
                          splashRadius: 1,
                          icon: Icon(passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: togglePassword,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListView(
                shrinkWrap: true,
                children: [
                  TextButton(
                    onPressed: () async {
                      final app = Provider.of<ApplicationModel>(
                        context,
                        listen: false,
                      );
                      final registerUrl = '${app.url}/forgot-password';
                      if (!await launch(registerUrl)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not launch URL.'),
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Forgot Password?'),
                    ),
                    style: buttonStyle,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: loading ? null : tryLogin,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(loading ? 'Loading...' : 'Login'),
                    ),
                    style: buttonStyle,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text('OR',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage(title: 'Noticebord'),
                              ),
                            );
                          },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Skip for now'),
                    ),
                    style: buttonStyle.copyWith(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor.withAlpha(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final app = Provider.of<ApplicationModel>(
                            context,
                            listen: false,
                          );
                          final registerUrl = '${app.url}/register';
                          if (!await launch(registerUrl)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Could not launch URL.'),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Register',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
