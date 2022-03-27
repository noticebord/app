import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
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
                  Text(
                    "Notice " + (position + 1).toString(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: List<Widget>.generate(
                          7,
                          (index) => ActionChip(
                            label: Text('#tag${index + 1}'),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("#tag${index + 1} clicked"),
                                ),
                              );
                            },
                          ),
                        )),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade800,
                        child: const Text('US'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "User",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      )
                    ],
                  )
                ],
              )),
        );
      },
    );
  }
}
