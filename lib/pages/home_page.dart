import 'package:app/screens/home_screen.dart';
import 'package:app/screens/notices_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/team_notices_screen.dart';
import 'package:app/screens/topics_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.authenticated}) : super(key: key);

  final String title;
  final bool authenticated;

  @override
  State<HomePage> createState() => _HomePageState(authenticated: authenticated);
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool authenticated;

  _HomePageState({required this.authenticated}) {
    _selectedIndex = authenticated ? 2 : 1;
  }

  final _pages = <Widget>[];

  void _onTap(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addNotice() {}

  @override
  Widget build(BuildContext context) {
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
          child: IndexedStack(index: _selectedIndex, children: _pages,)
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
        currentIndex: _selectedIndex,
        selectedItemColor: ThemeData.light().primaryColor,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          if (authenticated) const BottomNavigationBarItem(icon: const Icon(Icons.group), label: "Team Notices"),
          const BottomNavigationBarItem(icon: const Icon(Icons.sticky_note_2), label: "Notices"),
          const BottomNavigationBarItem(icon: const Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(icon: const Icon(Icons.tag), label: "Topics"),
          if (authenticated) const BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNotice,
        tooltip: 'Add a Notice',
        child: const Icon(Icons.add),
      ),
    );
  }
}
