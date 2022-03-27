import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeamNoticesScreen extends StatefulWidget {
  const TeamNoticesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamNoticesScreenState();
}

class _TeamNoticesScreenState extends State<TeamNoticesScreen> {
  String _currentTeam = "Team #5";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              ActionChip(
                  label: Text(_currentTeam),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Select a Team",
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: 40,
                                itemBuilder: (context, position) {
                                  return ListTile(
                                    tileColor:
                                        "Team #${position + 1}" == _currentTeam
                                            ? Colors.blue[50]
                                            : null,
                                    subtitle:
                                        "Team #${position + 1}" == _currentTeam
                                            ? const Text("Currently selected")
                                            : null,
                                    title: Text("Team #${position + 1}"),
                                    onTap: () {
                                      setState(() {
                                        _currentTeam = "Team #${position + 1}";
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 20,
            itemBuilder: (context, position) {
              return Card(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "Notice " + (position + 1).toString(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 24.0),
                          ),
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
            },
          ),
        ),
      ],
    );
  }
}
