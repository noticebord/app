  import 'package:app/client/models/nested_topic.dart';
import 'package:app/pages/topic_details_page.dart';
import 'package:flutter/material.dart';

class TopicListWidget extends StatefulWidget {
  final List<NestedTopic> topics;

  const TopicListWidget({required this.topics, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopicListWidgetState();
  }
}

class _TopicListWidgetState extends State<TopicListWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: List<Widget>.generate(
        widget.topics.length,
        (index) {
          final topic = widget.topics[index];
          return ActionChip(
            label: Text("#${topic.name}"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicDetailsPage(topicId: topic.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
