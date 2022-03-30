import 'package:app/client/models/list_team_notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/models/team.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../application_model.dart';

class TeamNoticesScreen extends StatefulWidget {
  const TeamNoticesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamNoticesScreenState();
}

class _TeamNoticesScreenState extends State<TeamNoticesScreen> {
  late Team _currentTeam;
  late List<Team> teams;
  late PaginatedList<ListTeamNotice> teamNotices;
  late NoticebordClient client;
  late Future futureScreen;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    futureScreen = loadTeamsAndNotices();
  }

  Future loadTeamsAndNotices([int? id]) async {
    client = Provider.of<ApplicationModel>(context, listen: false).client;
    teams = await client.teams.getTeams();
    _currentTeam = id == null ? teams[0] : teams.singleWhere((element) => element.id == id);
    teamNotices = await client.teamNotices.getTeamNotices(_currentTeam.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureScreen,
        builder: (context, snapshot) {
          final done = snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError;
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
                                                subtitle: team.id ==
                                                        _currentTeam.id
                                                    ? const Text(
                                                        "Currently selected")
                                                    : null,
                                                title: Text(team.name),
                                                onTap: () {
                                                  setState(() {
                                                    _currentTeam = team;
                                                    futureScreen = loadTeamsAndNotices(team.id);
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
              Expanded(
                child: !done
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: teamNotices.nextPageUrl == null ? teamNotices.data.length :  teamNotices.data.length + 1,
                        itemBuilder: (context, position) {
                          if (position < teamNotices.data.length) {
                            final notice = teamNotices.data[position];
                            return Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                        child: Text(notice.title,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontSize: 24.0),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.grey
                                                .shade800,
                                            child: Text(notice.author.name[0]),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              notice.author.name,
                                              style: Theme
                                                  .of(context)
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
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: loading ? const CircularProgressIndicator() : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });

                                  final cursor = Uri.parse(teamNotices.nextPageUrl!).queryParameters['cursor'];
                                  final notices = teamNotices.data;
                                  final tNotices = await client.teamNotices.getTeamNotices(_currentTeam.id, cursor: cursor);

                                  setState(() {
                                    teamNotices = tNotices;
                                    teamNotices.data = [...notices, ...teamNotices.data];
                                    loading = false;
                                  });
                                },
                                child: const Text("Load more"),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        });
  }
}
