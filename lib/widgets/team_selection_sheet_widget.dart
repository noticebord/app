import 'package:app/client/models/team.dart';
import 'package:flutter/material.dart';

class TeamSelectionSheetWidget extends StatefulWidget {
  final List<Team> teams;
  final Team currentTeam;
  final Function(Team) onSelected;
  const TeamSelectionSheetWidget({
    Key? key,
    required this.teams,
    required this.currentTeam,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamSelectionSheetWidgetState();
}

class _TeamSelectionSheetWidgetState extends State<TeamSelectionSheetWidget> {
  @override
  Widget build(BuildContext context) {
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
                    'Select a Team',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1.0),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.teams.length,
              itemBuilder: (context, position) {
                final team = widget.teams[position];
                return ListTile(
                  tileColor:
                      team.id == widget.currentTeam.id ? Colors.blue[50] : null,
                  subtitle: team.id == widget.currentTeam.id
                      ? const Text('Currently selected')
                      : null,
                  title: Text(team.name),
                  onTap: () => widget.onSelected(team),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
