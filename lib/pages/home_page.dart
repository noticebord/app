import 'package:animations/animations.dart';
import 'package:app/application_model.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/pages/new_notice_page.dart';
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

  @override
  void initState() {
    super.initState();
    final app = Provider.of<ApplicationModel>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      final page = app.token == null ? 1 : 2;
      app.setPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationModel>(
      builder: (context, app, child) {
        final authenticated = app.token != null;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              const IconButton(onPressed: null, icon: Icon(Icons.dark_mode)),
              authenticated
                  ? IconButton(
                      icon: const Icon(Icons.logout),
                      tooltip: "Log out",
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove("token");
                        await prefs.remove("user");
                        app.removeAuth();
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
            ],
          ),
          body: Center(
            child: IndexedStack(
              index: app.page,
              children: [
                if (authenticated) const TeamNoticesScreen(),
                const NoticesScreen(),
                const HomeScreen(),
                const TopicsScreen(),
                if (authenticated) const ProfileScreen(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: _onTap,
            currentIndex: app.page,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: <BottomNavigationBarItem>[
              if (authenticated)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: "Team Notices",
                ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.sticky_note_2),
                label: "Notices",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.tag),
                label: "Topics",
              ),
              if (authenticated)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: "Profile",
                ),
            ],
          ),
          floatingActionButton: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            openBuilder: (context, openContainer) => const NewNoticePage(),
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
            closedColor: Theme.of(context).colorScheme.secondary,
            closedBuilder: (context, openContainer) {
              return FloatingActionButton.extended(
                onPressed: openContainer,
                icon: const Icon(Icons.add),
                label: const Text("Create"),
              );
            },
          ),
        );
      },
    );
  }
}
