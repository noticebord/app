import 'package:app/application_model.dart';
import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/notice.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/client/requests/save_notice_request.dart';
import 'package:app/models/taggable_topic.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:provider/provider.dart';

class EditNoticePage extends StatefulWidget {
  final int noticeId;

  const EditNoticePage({Key? key, required this.noticeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditNoticePageState();
}

class _EditNoticePageState extends State<EditNoticePage> {
  late ApplicationModel app;
  late NoticebordClient client;

  final bool loading = false;
  final _formKey = GlobalKey<FormState>();

  late Future future;
  late Notice notice;
  late List<TaggableTopic> taggableTopics;
  late List<TaggableTopic> selectedTopics;
  late SaveNoticeRequest request;

  @override
  void initState() {
    super.initState();
    app = Provider.of<ApplicationModel>(context, listen: false);
    client = app.client;
    future = loadContent();
  }

  Future loadContent() async {
    notice = await client.notices.fetchNotice(widget.noticeId);
    final topics = await client.topics.fetchTopics();
    taggableTopics = topics.map((t) => TaggableTopic(t.name, t.count)).toList();

    final nestedTopics = notice.topics.map((t) => t.name).toList();
    selectedTopics = topics
        .where((t) => nestedTopics.contains(t.name))
        .map((t) => TaggableTopic(t.name, t.count))
        .toList();
    request =
        SaveNoticeRequest(notice.title, notice.body, nestedTopics, false, true);
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
            title: const Text('Edit Notice'),
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
                          final newNotice = await client.notices
                              .updateNotice(notice.id, request);
                          if (!request.public) {
                            app.removeNotice(notice.id);
                          } else {
                            // TODO: Should Notice extend ListNotice?
                            app.updateNotice(
                              notice.id,
                              ListNotice(
                                newNotice.id,
                                newNotice.title,
                                newNotice.createdAt,
                                newNotice.updatedAt,
                                newNotice.topics,
                                newNotice.author,
                              ),
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notice saved successfully!'),
                            ),
                          );
                          Navigator.of(context).pop(true);
                        } on Exception {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to save notice.')
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
                            hintText: 'My Awesome Notice!',
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
                                'Hi everyone! This is a notice on Noticebord.',
                            labelText: 'Body',
                          ),
                          onSaved: (value) => request.body = value ?? '',
                          initialValue: request.body,
                          maxLines: 10,
                          minLines: 1,
                          validator: validateNotEmpty,
                        ),
                        const SizedBox(height: 16),
                        FlutterTagging<TaggableTopic>(
                          initialItems: selectedTopics,
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: inputDecoration.copyWith(
                              hintText: 'fun, entertainment, work, ...',
                              labelText: 'Topics',
                            ),
                          ),
                          findSuggestions: (pattern) {
                            return taggableTopics
                                .where((t) => t.name
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .toList();
                          },
                          additionCallback: (value) => TaggableTopic(value, 0),
                          onAdded: (taggableTopic) {
                            setState(() => taggableTopics.add(taggableTopic));
                            return taggableTopic;
                          },
                          configureSuggestion: (topic) {
                            return SuggestionConfiguration(
                              title: Text('#${topic.name}'),
                              subtitle: Text('${topic.count} notices'),
                              additionWidget: Chip(
                                avatar: const Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                ),
                                label: const Text('Create Topic'),
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                          configureChip: (topic) {
                            return ChipConfiguration(
                              label: Text('#${topic.name}'),
                              backgroundColor: Theme.of(context).primaryColor,
                              labelStyle: const TextStyle(color: Colors.white),
                              deleteIconColor: Colors.white,
                            );
                          },
                          onChanged: () {
                            setState(() {
                              request.topics =
                                  selectedTopics.map((e) => e.name).toList();
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Anonymous'),
                          subtitle: const Text(
                              'Anonymous notices are not linked to you in any way, and cannot be edited or deleted by you after they are created.'),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: request.anonymous,
                          onChanged: (anonymous) {
                            setState(() {
                              request.anonymous = anonymous;
                              if (anonymous) {
                                request.public = true;
                              }
                            });
                          },
                          secondary: Icon(request.anonymous
                              ? Icons.person_off
                              : Icons.person),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Public'),
                          subtitle: const Text(
                              'Public notices are visible to everyone, and may or may not be anonymous.'),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: request.public,
                          onChanged: request.anonymous
                              ? null
                              : (public) {
                                  setState(() => request.public = public);
                                },
                          secondary: Icon(
                              request.public ? Icons.public : Icons.public_off),
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
