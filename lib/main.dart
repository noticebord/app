import 'package:app/screens/home_screen.dart';
import 'package:app/screens/notices_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/team_notices_screen.dart';
import 'package:app/screens/topics_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const NoticebordApp());
}

class NoticebordApp extends StatelessWidget {
  const NoticebordApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noticebord',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Noticebord'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  final _pages = <Widget>[
    const TeamNoticesScreen(),
    const NoticesScreen(),
    const HomeScreen(),
    const TopicsScreen(),
    const ProfileScreen(),
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Team Notices"),
          BottomNavigationBarItem(icon: Icon(Icons.sticky_note_2), label: "Notices"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.tag), label: "Topics"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
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
