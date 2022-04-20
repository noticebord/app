import 'package:animations/animations.dart';
import 'package:app/application_model.dart';
import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/models/topic.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/pages/notice_details_page.dart';
import 'package:app/widgets/list_notice_widget.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:app/widgets/loading_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicDetailsPage extends StatefulWidget {
  final int topicId;
  const TopicDetailsPage({Key? key, required this.topicId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  bool loading = false;
  late NoticebordClient client;

  late Topic topic;
  late PaginatedList<ListNotice> lastResponse;

  late Future futureTopicDetails;

  Future fetchTopic(int topicId) async {
    topic = await client.topics.fetchTopic(topicId);
  }

  Future fetchTopicNotices(int topicId) async {
    final app = Provider.of<ApplicationModel>(context, listen: false);
    lastResponse = await client.topics.fetchTopicNotices(topicId);
    app.setTopicNotices(lastResponse.data);
  }

  @override
  void initState() {
    super.initState();
    final topicId = widget.topicId;

    client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureTopicDetails =
        Future.wait<void>([fetchTopic(topicId), fetchTopicNotices(topicId)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topic Details')),
      body: FutureBuilder(
        future: futureTopicDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasData) {
            return const LoaderWidget();
          }

          return Consumer<ApplicationModel>(
            builder: (context, app, child) {
              final itemCount = lastResponse.nextPageUrl == null
                  ? app.topicNotices.length + 1
                  : app.topicNotices.length + 2;
              return ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, position) {
                  if (position == 0) {
                    return MaterialBanner(
                      content: Text('#${topic.name} - ${topic.count} notices'),
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Icon(Icons.add),
                              SizedBox(width: 4.0),
                              Text('Create New'),
                            ],
                          ),
                        )
                      ],
                    );
                  }

                  if (position < app.topicNotices.length + 1) {
                    final notice = app.topicNotices[position - 1];
                    return OpenContainer<bool>(
                      transitionType: ContainerTransitionType.fade,
                      openBuilder: (context, openContainer) {
                        return NoticeDetailsPage(noticeId: notice.id);
                      },
                      tappable: false,
                      closedShape: const RoundedRectangleBorder(),
                      closedElevation: 0,
                      closedBuilder: (context, openContainer) {
                        return ListNoticeWidget(
                          listNotice: notice,
                          onTap: openContainer,
                        );
                      },
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: LoadingButtonWidget(
                      loading: loading,
                      elevated: false,
                      child: const Text('Load more'),
                      onPressed: () async {
                        setState(() => loading = true);

                        final cursor = Uri.parse(lastResponse.nextPageUrl!)
                            .queryParameters['cursor'];
                        lastResponse = await client.topics
                            .fetchTopicNotices(topic.id, cursor: cursor);

                        setState(() {
                          app.addTopicNotices(lastResponse.data);
                          loading = false;
                        });
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
