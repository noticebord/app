import 'package:app/application_model.dart';
import 'package:app/client/models/notice.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:app/widgets/notice_author_widget.dart';
import 'package:app/widgets/topic_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeDetailsPage extends StatefulWidget {
  final int noticeId;
  const NoticeDetailsPage({Key? key, required this.noticeId}) : super(key: key);

  @override
  State createState() {
    return _NoticeDetailsPageState();
  }
}

class _NoticeDetailsPageState extends State<NoticeDetailsPage> {
  late Future<Notice> futureNotice;

  @override
  void initState() {
    super.initState();
    final client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureNotice = client.notices.fetchNotice(widget.noticeId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice Details")
      ),
      body: FutureBuilder<Notice>(
        future: futureNotice,
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
                        // color: Colors.black54,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      notice.body,
                      style: textTheme.bodyText2!.copyWith(
                        // color: Colors.black54,
                        height: 1.5,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TopicListWidget(topics: notice.topics),
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
