import 'package:app/application_model.dart';
import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/paginated.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  bool loading = false;
  late Future<Paginated<List<ListNotice>>> futureNotices;
  late NoticebordClient client;

  @override
  void initState() {
    super.initState();
    client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureNotices = client.notices.getNotices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Paginated<List<ListNotice>>>(
      future: futureNotices,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var response = snapshot.data!;
          return ListView.builder(
            itemCount: response.nextPageUrl == null
                ? response.data.length
                : response.data.length + 1,
            itemBuilder: (context, position) {
              if (position < response.data.length) {
                final notice = response.data[position];
                return Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notice.title,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 24.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: List<Widget>.generate(
                                  notice.topics.length,
                                  (index) {
                                    final topic = notice.topics[index];
                                    return ActionChip(
                                      label: Text("#${topic.name}"),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text("#${topic.name} clicked"),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade800,
                                child: const Text('US'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "User",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: loading ? const CircularProgressIndicator() : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      final cursor = Uri.parse(response.nextPageUrl!).queryParameters['cursor'];
                      final notices = response.data;
                      futureNotices = client.notices.getNotices(cursor: cursor);

                      setState(() async {
                        response = await futureNotices;
                        response.data = [...notices, ...response.data];
                        loading = false;
                      });
                    },
                    child: const Text("Load more"),
                  ),
                ),
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
