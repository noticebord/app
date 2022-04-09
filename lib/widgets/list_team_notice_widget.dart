import 'package:app/client/models/list_team_notice.dart';
import 'package:app/widgets/notice_author_widget.dart';
import 'package:flutter/material.dart';

class ListTeamNoticeWidget extends StatefulWidget {
  final ListTeamNotice listTeamNotice;
  final VoidCallback onTap;
  const ListTeamNoticeWidget(
      {Key? key, required this.listTeamNotice, required this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListTeamNoticeWidgetState();
}

class _ListTeamNoticeWidgetState extends State<ListTeamNoticeWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.listTeamNotice.title,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
            NoticeAuthorWidget(author: widget.listTeamNotice.author)
          ],
        ),
      ),
    ));
  }
}
