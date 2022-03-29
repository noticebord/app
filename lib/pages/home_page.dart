import 'package:app/screens/home_screen.dart';
import 'package:app/screens/notices_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/team_notices_screen.dart';
import 'package:app/screens/topics_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const bool _isAuthenticated = false;
  int _selectedIndex = _isAuthenticated ? 2 : 1;

  final _pages = <Widget>[
    if (_isAuthenticated) const TeamNoticesScreen(),
    const NoticesScreen(),
    const HomeScreen(),
    const TopicsScreen(),
    if (_isAuthenticated) const ProfileScreen(),
  ];

  void _onTap(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addNotice() {}

  @override
  Widget build(BuildContext context) {
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
        items: const <BottomNavigationBarItem>[
          if (_isAuthenticated) BottomNavigationBarItem(icon: Icon(Icons.group), label: "Team Notices"),
          BottomNavigationBarItem(icon: Icon(Icons.sticky_note_2), label: "Notices"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.tag), label: "Topics"),
          if (_isAuthenticated) BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
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
