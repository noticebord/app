import 'package:app/application_model.dart';
import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/widgets/list_notice_widget.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:app/widgets/loading_button_widget.dart';
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
  late Future<PaginatedList<ListNotice>> futureNotices;
  late NoticebordClient client;

  @override
  void initState() {
    super.initState();
    client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureNotices = client.notices.fetchNotices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaginatedList<ListNotice>>(
      future: futureNotices,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var publicNotices = snapshot.data!;
          return ListView.builder(
            itemCount: publicNotices.nextPageUrl == null
                ? publicNotices.data.length
                : publicNotices.data.length + 1,
            itemBuilder: (context, position) {
              if (position < publicNotices.data.length) {
                final notice = publicNotices.data[position];
                return ListNoticeWidget(listNotice: notice);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: LoadingButtonWidget(
                  loading: loading,
                  elevated: false,
                  child: const Text("Load more"),
                  onPressed: () async {
                    setState(() => loading = true);

                    final cursor = Uri.parse(publicNotices.nextPageUrl!)
                        .queryParameters['cursor'];
                    final notices = publicNotices.data;
                    futureNotices = client.notices.fetchNotices(cursor: cursor);
                    final pNotices = await futureNotices;

                    setState(() {
                      publicNotices = pNotices;
                      publicNotices.data = [...notices, ...publicNotices.data];
                      loading = false;
                    });
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const LoaderWidget();
      },
    );
  }
}
