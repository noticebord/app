import 'package:app/application_model.dart';
import 'package:app/client/models/list_team_notice.dart';
import 'package:app/client/models/team.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/client/requests/save_team_notice_request.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTeamNoticePage extends StatefulWidget {
  const NewTeamNoticePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTeamNoticePageState();
}

class _NewTeamNoticePageState extends State<NewTeamNoticePage> {
  late ApplicationModel app;
  late NoticebordClient client;

  final bool loading = false;
  final _formKey = GlobalKey<FormState>();

  late Future future;
  late SaveTeamNoticeRequest request;
  late List<Team> teams;

  late Team selectedTeam;

  @override
  void initState() {
    super.initState();
    app = Provider.of<ApplicationModel>(context, listen: false);
    client = app.client;
    future = loadContent();
  }

  Future loadContent() async {
    teams = await client.teams.fetchTeams();
    selectedTeam = teams[0];
    request = SaveTeamNoticeRequest();
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Theme.of(context).primaryColor.withAlpha(30),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        final done = snapshot.connectionState == ConnectionState.done;
        return Scaffold(
          appBar: AppBar(
            title: const Text('New Team Notice'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: !done || loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        _formKey.currentState!.save();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saving notice...')),
                        );

                        try {
                          final newNotice = await client.teamNotices
                              .createTeamNotice(selectedTeam.id, request);

                          // TODO: Should TeamNotice extend ListTeamNotice?
                          app.addTeamNotices([
                            ListTeamNotice(
                              newNotice.id,
                              newNotice.title,
                              newNotice.createdAt,
                              newNotice.updatedAt,
                              newNotice.author,
                            )
                          ]);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notice saved successfully!'),
                            ),
                          );
                          Navigator.of(context).pop(true);
                        } on Exception {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to save notice.'),
                            ),
                          );
                        }
                      },
              ),
            ],
          ),
          body: done
              ? Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<Team>(
                          decoration: inputDecoration.copyWith(
                            hintText: 'Select one',
                            labelText: 'Team',

                          ),
                          items: teams
                              .map<DropdownMenuItem<Team>>(
                                (t) => DropdownMenuItem<Team>(
                                  value: t,
                                  child: Text(t.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              selectedTeam = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: inputDecoration.copyWith(
                            hintText: 'My Awesome Team Notice!',
                            labelText: 'Title',
                          ),
                          onSaved: (value) => request.title = value ?? '',
                          initialValue: request.title,
                          validator: validateNotEmpty,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: inputDecoration.copyWith(
                            hintText:
                                'Hi everyone! This is a team notice on Noticebord.',
                            labelText: 'Body',
                          ),
                          onSaved: (value) => request.body = value ?? '',
                          initialValue: request.body,
                          maxLines: 10,
                          minLines: 1,
                          validator: validateNotEmpty,
                        ),
                      ],
                    ),
                  ),
                )
              : const LoaderWidget(),
        );
      },
    );
  }
}
