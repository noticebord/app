import 'package:app/client/models/topic.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late Future<List<Topic>> futureTopics;

  @override
  void initState() {
    super.initState();
    var client = NoticebordClient("");
    futureTopics = client.topics.getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: futureTopics,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, position) {
              final topic = snapshot.data![position];
              return Card(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "#${topic.name}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 24.0),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${topic.count} ",
                            style: Theme.of(context).textTheme.bodyText1,
                            children: const [TextSpan(text: "notices")],
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
