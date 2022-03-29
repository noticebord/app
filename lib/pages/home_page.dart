import 'package:app/application_model.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/notices_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/team_notices_screen.dart';
import 'package:app/screens/topics_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onTap(int index) {
    Provider.of<ApplicationModel>(context, listen: false).setPage(index);
  }

  void _addNotice() {}

  @override
  void initState() {
    super.initState();
    final app = Provider.of<ApplicationModel>(context, listen: false);
    app.setPage(app.token == null ? 1 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationModel>(
      builder: (context, app, child) {
        final authenticated = app.token != null;
        return Scaffold(
          appBar: AppBar(title: Text(widget.title), actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.dark_mode)),
            authenticated
                ? IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: "Log out",
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove("token");
                      app.setToken(null);
                      app.setPage(1);
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.login),
                    tooltip: "Log in",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  )
          ]),
          body: Center(
            child: IndexedStack(index: app.page, children: [
              if (authenticated) const TeamNoticesScreen(),
              const NoticesScreen(),
              const HomeScreen(),
              const TopicsScreen(),
              if (authenticated) const ProfileScreen(),
            ]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: _onTap,
            currentIndex: app.page,
            selectedItemColor: ThemeData.light().primaryColor,
            unselectedItemColor: Colors.grey,
            items: <BottomNavigationBarItem>[
              if (authenticated)
                const BottomNavigationBarItem(
                    icon: Icon(Icons.group), label: "Team Notices"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.sticky_note_2), label: "Notices"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Home"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.tag), label: "Topics"),
              if (authenticated)
                const BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: "Profile"),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addNotice,
            tooltip: 'Add a Notice',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
