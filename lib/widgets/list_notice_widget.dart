import 'package:app/client/models/list_notice.dart';
import 'package:app/widgets/notice_author_widget.dart';
import 'package:app/widgets/topic_list_widget.dart';
import 'package:flutter/material.dart';

class ListNoticeWidget extends StatefulWidget {
  final ListNotice listNotice;
  final VoidCallback onTap;
  const ListNoticeWidget(
      {Key? key, required this.listNotice, required this.onTap})
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
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.title,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              TopicListWidget(
                topics: notice.topics,
                onPressed: (topic) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("#${topic.name} clicked")),
                  );
                },
              ),
              const SizedBox(height: 12.0),
              NoticeAuthorWidget(author: notice.author)
            ],
          ),
        ),
      ),
    );
  }
}
