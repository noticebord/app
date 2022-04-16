import 'package:animations/animations.dart';
import 'package:app/application_model.dart';
import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/pages/notice_details_page.dart';
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
  late Future futureNotices;
  late NoticebordClient client;
  late PaginatedList<ListNotice> lastResponse;

  @override
  void initState() {
    super.initState();
    client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureNotices = setNotices();
  }

  Future setNotices() async {
    final app = Provider.of<ApplicationModel>(context, listen: false);
    lastResponse = await client.notices.fetchNotices();
    app.setNotices(lastResponse.data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureNotices,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoaderWidget();
        }

        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Consumer<ApplicationModel>(
          builder: (context, app, child) {
            return ListView.builder(
              itemCount: lastResponse.nextPageUrl == null
                  ? app.notices.length
                  : app.notices.length + 1,
              itemBuilder: (context, position) {
                if (position < app.notices.length) {
                  final notice = app.notices[position];
                  return OpenContainer<bool>(
                    transitionType: ContainerTransitionType.fade,
                    openBuilder: (context, openContainer) {
                      return NoticeDetailsPage(noticeId: notice.id);
                    },
                    tappable: false,
                    closedShape: const RoundedRectangleBorder(),
                    closedElevation: 0,
                    closedBuilder: (context, openContainer) {
                      return ListNoticeWidget(
                        listNotice: notice,
                        onTap: openContainer,
                      );
                    },
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: LoadingButtonWidget(
                    loading: loading,
                    elevated: false,
                    child: const Text("Load more"),
                    onPressed: () async {
                      setState(() => loading = true);

                      final cursor = Uri.parse(lastResponse.nextPageUrl!)
                          .queryParameters['cursor'];
                      final newResponse =
                          await client.notices.fetchNotices(cursor: cursor);
                      app.addNotices(newResponse.data);

                      setState(() {
                        lastResponse = newResponse;
                        loading = false;
                      });
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
