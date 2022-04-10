import 'package:app/application_model.dart';
import 'package:app/client/models/topic.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicDetailsPage extends StatefulWidget {
  final int topicId;
  const TopicDetailsPage({Key? key, required this.topicId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  late Future<Topic> futureTopic;

  @override
  void initState() {
    super.initState();
    final client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureTopic = client.topics.fetchTopic(widget.topicId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Topic Details")),
      body: FutureBuilder<Topic>(
        future: futureTopic,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasData) {
            return const LoaderWidget();
          }

          final topic = snapshot.data!;
          return ListView(
            children: [
              MaterialBanner(
                content: Text("#${topic.name} - ${topic.count} notices"),
                actions: [
                  TextButton(
                    onPressed: null,
                    child: Row(children: const [
                      Icon(Icons.add),
                      SizedBox(width: 4.0),
                      Text("New Notice"),
                    ]),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
