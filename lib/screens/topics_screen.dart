import 'package:animations/animations.dart';
import 'package:app/application_model.dart';
import 'package:app/client/models/topic.dart';
import 'package:app/pages/topic_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureTopics = client.topics.fetchTopics();
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
              return OpenContainer<bool>(
                transitionType: ContainerTransitionType.fade,
                openBuilder: (context, openContainer) => TopicDetailsPage(
                  topicId: topic.id,
                ),
                tappable: false,
                closedShape: const RoundedRectangleBorder(),
                closedElevation: 0,
                closedBuilder: (context, openContainer) {
                  return Card(
                    child: InkWell(
                      onTap: openContainer,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  '#${topic.name}',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '${topic.count} ',
                                  style: Theme.of(context).textTheme.subtitle1,
                                  children: const [TextSpan(text: 'notices')],
                                ),
                              ),
                            ],
                          )),
                    ),
                  );
                },
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
