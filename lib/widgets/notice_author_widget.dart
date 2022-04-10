import 'package:app/client/models/user.dart';
import 'package:flutter/material.dart';

class NoticeAuthorWidget extends StatefulWidget {
  final User? author;
  const NoticeAuthorWidget({Key? key, required this.author}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NoticeAuthorWidgetState();
  }
}

class _NoticeAuthorWidgetState extends State<NoticeAuthorWidget> {
  @override
  Widget build(BuildContext context) {
    final author = widget.author;
    final titleLarge = Theme.of(context).textTheme.titleMedium;

    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: Theme.of(context).primaryColor,
          child: author == null
              ? const CircleAvatar(child: Icon(Icons.person_off, size: 20))
              : CircleAvatar(
                  backgroundImage: NetworkImage(author.profilePhotoUrl),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: author == null
              ? Text(
                  "Anonymous",
                  style: titleLarge!.copyWith(fontStyle: FontStyle.italic),
                )
              : Text(author.name, style: titleLarge),
        )
      ],
    );
  }
}
