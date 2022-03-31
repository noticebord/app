import 'package:app/client/models/list_team_notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/models/team.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:app/widgets/loader_widget.dart';
import 'package:app/widgets/loading_button_widget.dart';
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
  List<ListTeamNotice> teamNotices = <ListTeamNotice>[];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureTeams = loadTeams();
  }

  Future loadTeams([int? id]) async {
    teams = await client.teams.getTeams();
    _currentTeam = id == null
        ? teams[0]
        : teams.singleWhere((element) => element.id == id);
    futureTeamNotices = loadTeamNotices(_currentTeam.id);
  }

  Future loadTeamNotices(int id) async {
    final response = await client.teamNotices.getTeamNotices(id);
    teamNotices.addAll(response.data);
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
                          avatar: CircleAvatar(
                            child: Text(_currentTeam.name[0]),
                          ),
                          label: Text(_currentTeam.name),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 300,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          top: 16.0,
                                          bottom: 8.0,
                                        ),
                                        child: SizedBox(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Select a Team",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                icon: const Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: teams.length,
                                          itemBuilder: (context, position) {
                                            final team = teams[position];
                                            return ListTile(
                                              tileColor:
                                                  team.id == _currentTeam.id
                                                      ? Colors.blue[50]
                                                      : null,
                                              subtitle:
                                                  team.id == _currentTeam.id
                                                      ? const Text(
                                                          "Currently selected")
                                                      : null,
                                              title: Text(team.name),
                                              onTap: () {
                                                setState(() {
                                                  teamNotices.clear();
                                                  _currentTeam = team;
                                                  futureTeamNotices =
                                                      loadTeamNotices(team.id);
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
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
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: lastResponse.nextPageUrl == null
                              ? teamNotices.length
                              : teamNotices.length + 1,
                          itemBuilder: (context, position) {
                            if (position < teamNotices.length) {
                              final notice = teamNotices[position];
                              return Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Text(
                                            notice.title,
                                            textAlign: TextAlign.start,
                                            style:
                                                const TextStyle(fontSize: 24.0),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              child:
                                                  Text(notice.author.name[0]),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                notice.author.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              );
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: LoadingButtonWidget(
                                loading: loading,
                                onPressed: () async {
                                  setState(() => loading = true);

                                  final cursor = Uri.parse(lastResponse.nextPageUrl!)
                                          .queryParameters['cursor'];
                                  lastResponse = await client.teamNotices
                                      .getTeamNotices(_currentTeam.id,
                                      cursor: cursor);

                                  setState(() {
                                    teamNotices.addAll(lastResponse.data);
                                    loading = false;
                                  });
                                },
                              ),
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
