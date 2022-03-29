import 'package:app/screens/home_screen.dart';
import 'package:app/screens/notices_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/team_notices_screen.dart';
import 'package:app/screens/topics_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _pages = <Widget>[];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void _addNotice() {}

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: loadToken(),
        builder: (context, snapshot) {
          String? token;

          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }

          token = snapshot.data;
          var authenticated = token != null;
          _selectedIndex = authenticated ? 2 : 1;
          _pages.addAll([
            if (authenticated) const TeamNoticesScreen(),
            const NoticesScreen(),
            const HomeScreen(),
            const TopicsScreen(),
            if (authenticated) const ProfileScreen(),
          ]);
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: Center(
              child: IndexedStack(index: _selectedIndex, children: _pages),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: _onTap,
              currentIndex: _selectedIndex,
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
        });
  }
}
