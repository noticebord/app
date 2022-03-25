import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeamNoticesScreen extends StatefulWidget {
  const TeamNoticesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamNoticesScreenState();
}

class _TeamNoticesScreenState extends State<TeamNoticesScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group,
            size: 100,
            color: ThemeData.light().primaryColor,
          ),
          Text(
            "Team Notices",
            style: Theme.of(context). textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
