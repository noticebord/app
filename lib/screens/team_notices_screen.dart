import 'package:animations/animations.dart';
import 'package:app/client/models/list_team_notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/models/team.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/pages/team_notice_details_page.dart';
import 'package:app/widgets/list_team_notice_widget.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:app/widgets/loading_button_widget.dart';
import 'package:app/widgets/team_selection_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../application_model.dart';

class TeamNoticesScreen extends StatefulWidget {
  const TeamNoticesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamNoticesScreenState();
}

class _TeamNoticesScreenState extends State<TeamNoticesScreen> {
  late NoticebordClient client;

  late Future futureTeams;
  late List<Team> teams;
  late Team _currentTeam;

  Future? futureTeamNotices;
  late PaginatedList<ListTeamNotice> lastResponse;
  // List<ListTeamNotice> teamNotices = <ListTeamNotice>[];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureTeams = loadTeams();
  }

  Future loadTeams([int? id]) async {
    teams = await client.teams.fetchTeams();
    _currentTeam = id == null
        ? teams[0]
        : teams.singleWhere((element) => element.id == id);
    futureTeamNotices = loadTeamNotices(_currentTeam.id);
  }

  Future loadTeamNotices(int id) async {
    final app = Provider.of<ApplicationModel>(context, listen: false);
    final response = await client.teamNotices.fetchTeamNotices(id);
    app.addTeamNotices(response.data);
    lastResponse = response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureTeams,
      builder: (context, snapshot) {
        final done = snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError;
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Spacer(),
                  done
                      ? ActionChip(
                          avatar:
                              CircleAvatar(child: Text(_currentTeam.name[0])),
                          label: Text(_currentTeam.name),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return TeamSelectionSheetWidget(
                                  teams: teams,
                                  currentTeam: _currentTeam,
                                  onSelected: (team) {
                                    final app = Provider.of<ApplicationModel>(
                                      context,
                                      listen: false,
                                    );
                                    setState(() {
                                      app.setTeamNotices([]);
                                      _currentTeam = team;
                                      futureTeamNotices =
                                          loadTeamNotices(team.id);
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          })
                      : ActionChip(
                          avatar: const CircularProgressIndicator(),
                          label: const Text("Loading..."),
                          onPressed: () {},
                        ),
                ],
              ),
            ),
            FutureBuilder(
              future: futureTeamNotices,
              builder: (context, snapshot) {
                return Expanded(
                  child: snapshot.connectionState != ConnectionState.done
                      ? const LoaderWidget()
                      : Consumer<ApplicationModel>(
                          builder: (context, app, child) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: lastResponse.nextPageUrl == null
                                  ? app.teamNotices.length
                                  : app.teamNotices.length + 1,
                              itemBuilder: (context, position) {
                                if (position < app.teamNotices.length) {
                                  final notice = app.teamNotices[position];
                                  return OpenContainer<bool>(
                                    transitionType:
                                        ContainerTransitionType.fade,
                                    openBuilder: (context, openContainer) {
                                      return TeamNoticeDetailsPage(
                                        teamId: _currentTeam.id,
                                        teamNoticeId: notice.id,
                                      );
                                    },
                                    tappable: false,
                                    closedShape: const RoundedRectangleBorder(),
                                    closedElevation: 0,
                                    closedBuilder: (context, openContainer) {
                                      return ListTeamNoticeWidget(
                                        listTeamNotice: notice,
                                        onTap: openContainer,
                                      );
                                    },
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: LoadingButtonWidget(
                                    loading: loading,
                                    elevated: false,
                                    child: const Text("Load more"),
                                    onPressed: () async {
                                      setState(() => loading = true);

                                      final cursor =
                                          Uri.parse(lastResponse.nextPageUrl!)
                                              .queryParameters['cursor'];
                                      lastResponse = await client.teamNotices
                                          .fetchTeamNotices(_currentTeam.id,
                                              cursor: cursor);

                                      setState(() {
                                        app.addTeamNotices(lastResponse.data);
                                        loading = false;
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
