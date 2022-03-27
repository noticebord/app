import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, position) {
        return Card(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "#topic" + (position + 1).toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                  const Text("5 notices"),
                ],
              )),
        );
      },
    );
  }
}
