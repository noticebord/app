import 'package:app/application_model.dart';
import 'package:app/client/models/list_team_notice.dart';
import 'package:app/client/models/team_notice.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/client/requests/save_team_notice_request.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTeamNoticePage extends StatefulWidget {
  final int teamId;
  final int teamNoticeId;

  const EditTeamNoticePage({
    Key? key,
    required this.teamId,
    required this.teamNoticeId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditTeamNoticePageState();
}

class _EditTeamNoticePageState extends State<EditTeamNoticePage> {
  late ApplicationModel app;
  late NoticebordClient client;

  final bool loading = false;
  final _formKey = GlobalKey<FormState>();

  late Future future;
  late TeamNotice notice;
  late SaveTeamNoticeRequest request;

  @override
  void initState() {
    super.initState();
    app = Provider.of<ApplicationModel>(context, listen: false);
    client = app.client;
    future = loadContent();
  }

  Future loadContent() async {
    notice = await client.teamNotices
        .fetchTeamNotice(widget.teamId, widget.teamNoticeId);
    request = SaveTeamNoticeRequest(title: notice.title, body: notice.body);
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
            title: const Text('Edit Team Notice'),
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
                              .updateTeamNotice(
                                  widget.teamId, notice.id, request);

                          // TODO: Should TeamNotice extend ListTeamNotice?
                          app.updateTeamNotice(
                            notice.id,
                            ListTeamNotice(
                              newNotice.id,
                              newNotice.title,
                              newNotice.createdAt,
                              newNotice.updatedAt,
                              newNotice.author,
                            ),
                          );

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
