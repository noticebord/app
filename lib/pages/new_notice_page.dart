import 'package:flutter/material.dart';

class NewNoticePage extends StatefulWidget {
  const NewNoticePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewNoticePageState();
}

class _NewNoticePageState extends State<NewNoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Notice'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: const Center(child: Text('Create notices.')),
    );
  }
}
