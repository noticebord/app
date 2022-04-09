import 'package:app/application_model.dart';
import 'package:app/client/models/team_notice.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:app/widgets/notice_author_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamNoticeDetailsPage extends StatefulWidget {
  final int teamId;
  final int teamNoticeId;
  const TeamNoticeDetailsPage({Key? key, required this.teamId, required this.teamNoticeId}) : super(key: key);

  @override
  State createState() {
    return _TeamNoticeDetailsPageState();
  }
}

class _TeamNoticeDetailsPageState extends State<TeamNoticeDetailsPage> {
  late Future<TeamNotice> futureTeamNotice;

  @override
  void initState() {
    super.initState();
    final client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureTeamNotice = client.teamNotices.fetchTeamNotice(widget.teamId, widget.teamNoticeId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Notice Details"),
      ),
      body: FutureBuilder<TeamNotice>(
        future: futureTeamNotice,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoaderWidget();
          }

          final notice = snapshot.data!;
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice.title,
                      style: textTheme.headline5!.copyWith(
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      notice.body,
                      style: textTheme.bodyText2!.copyWith(
                        height: 1.5,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    NoticeAuthorWidget(author: notice.author)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
