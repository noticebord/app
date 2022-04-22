import 'package:flutter/material.dart';

class NewTeamNoticePage extends StatefulWidget {
  const NewTeamNoticePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTeamNoticePageState();
}

class _NewTeamNoticePageState extends State<NewTeamNoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team Notice'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: const Center(child: Text('Create team notices.')),
    );
  }
}
