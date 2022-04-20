import 'package:app/application_model.dart';
import 'package:app/client/models/team_notice.dart';
import 'package:app/pages/edit_team_notice_page.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:app/widgets/notice_author_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamNoticeDetailsPage extends StatefulWidget {
  final int teamId;
  final int teamNoticeId;
  const TeamNoticeDetailsPage(
      {Key? key, required this.teamId, required this.teamNoticeId})
      : super(key: key);

  @override
  State createState() {
    return _TeamNoticeDetailsPageState();
  }
}

class _TeamNoticeDetailsPageState extends State<TeamNoticeDetailsPage> {
  late Future futureTeamNotice;
  late TeamNotice teamNotice;

  @override
  void initState() {
    super.initState();
    futureTeamNotice = setTeamNotice();
  }

  Future setTeamNotice() async {
    final client = Provider.of<ApplicationModel>(context, listen: false).client;
    teamNotice = await client.teamNotices
        .fetchTeamNotice(widget.teamId, widget.teamNoticeId);
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<ApplicationModel>(context);
    final textTheme = Theme.of(context).textTheme;

    Future<void> _showConfirmDeleteDialog() async {
      bool shouldDelete = false;

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Team Notice?'),
            content: SingleChildScrollView(
              child: Column(
                children: const <Widget>[
                  Text('Would you like to delete this team notice?'),
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
                    const SnackBar(content: Text('Deleting team notice...')),
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
          await app.client.teamNotices
              .deleteTeamNotice(widget.teamId, teamNotice.id);
          app.removeTeamNotice(teamNotice.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your notice was deleted.')),
          );
          Navigator.pop(context);
        } on Exception {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your notice could not be deleted.')),
          );
        }
      }
    }

    return FutureBuilder(
      future: futureTeamNotice,
      builder: (context, snapshot) {
        final done = snapshot.connectionState == ConnectionState.done;
        return Scaffold(
          appBar: AppBar(title: const Text('Team Notice Details'), actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: done && teamNotice.author.id == app.user
                  ? () async {
                      final route = MaterialPageRoute<bool>(builder: (context) {
                        return EditTeamNoticePage(
                          teamId: widget.teamId,
                          teamNoticeId: teamNotice.id,
                        );
                      });
                      final dirty = await Navigator.push<bool>(context, route);
                      if (dirty != null && dirty) {
                        setState(() {
                          futureTeamNotice = setTeamNotice();
                        });
                      }
                    }
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: done && teamNotice.author.id == app.user
                  ? _showConfirmDeleteDialog
                  : null,
            ),
          ]),
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
                            teamNotice.title,
                            style: textTheme.headline5!.copyWith(
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            teamNotice.body,
                            style: textTheme.bodyText2!.copyWith(
                              height: 1.5,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          NoticeAuthorWidget(author: teamNotice.author)
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
