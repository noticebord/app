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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tag,
            size: 100,
            color: ThemeData.light().primaryColor,
          ),
          Text(
            "Topics",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
