import 'package:app/client/models/user.dart';

class ListTeamNotice {
  int id;
  String title;
  String createdAt;
  String updatedAt;
  User author;

  ListTeamNotice(this.id, this.title, this.createdAt, this.updatedAt,
      this.author);

  factory ListTeamNotice.fromJSON(Map<String, dynamic> parsedJson) {
    return ListTeamNotice(
      parsedJson['id'],
      parsedJson['title'],
      parsedJson['created_at'],
      parsedJson['updated_at'],
      User.fromJSON(parsedJson['author']),
    );
  }
}
