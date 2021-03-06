import 'package:app/application_model.dart';
import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/nested_topic.dart';
import 'package:app/client/models/user.dart';
import 'package:app/client/utilities/notice_utilities.dart';
import 'package:app/widgets/topic_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late Future futureProfile;
  late User user;
  late List<ListNotice> userNotices;
  late List<ListNotice> userNotes;
  late int topicsPostedIn;
  late List<NestedTopic> frequentTopics;

  var _viewPrivate = false;

  @override
  void initState() {
    super.initState();
    futureProfile = loadUserAndNotices();
  }

  Future loadUserAndNotices() async {
    final app = Provider.of<ApplicationModel>(context, listen: false);
    final client = app.client;
    final userId = app.user!;

    await Future.wait<void>([
      (() async => user = await client.users.fetchUser(userId))(),
      (() async => userNotices = await client.users.fetchUserNotices(userId))(),
      (() async => userNotes = await client.users.fetchUserNotes(userId))(),
    ]);

    final countMap = NoticeUtilities.generateTopicCounts(userNotices);
    topicsPostedIn = countMap.length;
    frequentTopics = NoticeUtilities.determineMostFrequent(countMap);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureProfile,
      builder: (context, snapshot) {
        final bodyText1 = Theme.of(context).textTheme.bodyText1;
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, bottom: 16.0, top: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: CircleAvatar(
                              radius: 75,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: CircleAvatar(
                                radius: 74,
                                backgroundImage:
                                    NetworkImage(user.profilePhotoUrl),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.qr_code),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.share),
                                color: const Color.fromRGBO(104, 117, 245, 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Overview',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: 'Joined On: ',
                                    style: bodyText1,
                                  ),
                                  TextSpan(
                                      text: DateTime.parse(user.createdAt)
                                          .toString()),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: 'Notices Posted: ',
                                    style: bodyText1,
                                  ),
                                  TextSpan(text: userNotices.length.toString()),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'Topics Posted In: ',
                                    style: bodyText1,
                                  ),
                                  TextSpan(text: topicsPostedIn.toString()),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'Most Used Topics: ',
                                    style: bodyText1,
                                  )
                                ],
                              ),
                            ),
                          ),
                          TopicListWidget(topics: frequentTopics),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Wrap(
                  spacing: 8.0,
                  children: <Widget>[
                    ChoiceChip(
                      label: const Text('Public'),
                      selected: !_viewPrivate,
                      avatar: const Icon(Icons.public),
                      onSelected: (value) {
                        if (value) setState(() => _viewPrivate = false);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Private'),
                      selected: _viewPrivate,
                      avatar: const Icon(Icons.public_off),
                      onSelected: (value) {
                        if (value) setState(() => _viewPrivate = true);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: _viewPrivate
                      ? const Text('Viewing private')
                      : const Text('Viewing public'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
