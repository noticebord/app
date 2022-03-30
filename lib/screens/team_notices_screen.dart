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
  bool loading = false;
  late Future<List<Team>> futureTeams;
  late NoticebordClient client;

  @override
  void initState() {
    super.initState();
    client = Provider.of<ApplicationModel>(context, listen: false).client;
    futureTeams = client.teams.getTeams();
    futureTeams.then((value) {
      _currentTeam = value[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Team>>(
        future: futureTeams,
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Spacer(),
                    snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data!.isNotEmpty
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
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, position) {
                                              final team =
                                                  snapshot.data![position];
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
            ],
          );
        });

    // Expanded(
    //   child: ListView.builder(
    //     scrollDirection: Axis.vertical,
    //     itemCount: 20,
    //     itemBuilder: (context, position) {
    //       return Card(
    //         child: Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.only(bottom: 16.0),
    //                   child: Text(
    //                     "Notice " + (position + 1).toString(),
    //                     textAlign: TextAlign.start,
    //                     style: const TextStyle(fontSize: 24.0),
    //                   ),
    //                 ),
    //                 Row(
    //                   children: [
    //                     CircleAvatar(
    //                       backgroundColor: Colors.grey.shade800,
    //                       child: const Text('US'),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 8.0),
    //                       child: Text(
    //                         "User",
    //                         style: Theme.of(context).textTheme.titleLarge,
    //                       ),
    //                     )
    //                   ],
    //                 )
    //               ],
    //             )),
    //       );
    //     },
    //   ),
    // ),
  }
}
