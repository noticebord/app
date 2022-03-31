import 'package:app/client/models/list_notice.dart';
import 'package:app/widgets/topic_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListNoticeWidget extends StatefulWidget {
  final ListNotice listNotice;
  const ListNoticeWidget({Key? key, required this.listNotice})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListNoticeWidgetState();
  }
}

class _ListNoticeWidgetState extends State<ListNoticeWidget> {
  @override
  Widget build(BuildContext context) {
    final notice = widget.listNotice;
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.title,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 24.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TopicListWidget(
                  topics: notice.topics,
                  onPressed: (topic) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("#${topic.name} clicked"),
                      ),
                    );
                  },
                ),
              ),

              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: const Text('U'),
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
  }
}
