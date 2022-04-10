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
        title: const Text("New Notice")
      ),
      body: const Center(child: Text("I will create a new notice here.")),
    );
  }
}
