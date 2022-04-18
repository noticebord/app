import 'package:app/application_model.dart';
import 'package:app/client/models/notice.dart';
import 'package:app/pages/edit_notice_page.dart';
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
  late Future futureNotice;
  late Notice notice;

  @override
  void initState() {
    super.initState();
    futureNotice = setNotice();
  }

  Future setNotice() async {
    final client = Provider.of<ApplicationModel>(context, listen: false).client;
    notice = await client.notices.fetchNotice(widget.noticeId);
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<ApplicationModel>(context);
    final textTheme = Theme.of(context).textTheme;

    Future<void> _showConfirmDeleteDialog() async {
      bool shouldDelete = false;

      await showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Notice?'),
            content: SingleChildScrollView(
              child: Column(
                children: const <Widget>[
                  Text('Would you like to delete this notice?'),
                  Text('This action is not reversible.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  shouldDelete = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Deleting notice...")),
                  );
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );

      if (shouldDelete) {
        try {
          await app.client.notices.deleteNotice(notice.id);
          app.removeNotice(notice.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Your notice was deleted.")),
          );
          Navigator.pop(context);
        } on Exception {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Your notice could not be deleted.")),
          );
        }
      }
    }

    return FutureBuilder(
      future: futureNotice,
      builder: (context, snapshot) {
        final done = snapshot.connectionState == ConnectionState.done;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Notice Details"),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: done &&
                        notice.author != null &&
                        notice.author!.id == app.user
                    ? () async {
                        final route = MaterialPageRoute<bool>(builder: (context) {
                          return EditNoticePage(noticeId: notice.id);
                        });
                        final dirty = await Navigator.push<bool>(context, route);
                        if (dirty != null && dirty) {
                          setState(() => futureNotice = setNotice());
                        }
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: done &&
                        notice.author != null &&
                        notice.author!.id == app.user
                    ? _showConfirmDeleteDialog
                    : null,
              ),
            ],
          ),
          body: !done
              ? const LoaderWidget()
              : ListView(
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
                ),
        );
      },
    );
  }
}
