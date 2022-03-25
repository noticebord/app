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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sticky_note_2,
            size: 100,
            color: ThemeData.light().primaryColor,
          ),
          Text(
            "Notices",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
