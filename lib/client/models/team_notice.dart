import 'package:app/client/models/user.dart';

class TeamNotice {
  int id;
  String title;
  String body;
  String createdAt;
  String updatedAt;
  User author;

  TeamNotice(this.id, this.title, this.body, this.createdAt, this.updatedAt,
      this.author);

  factory TeamNotice.fromJSON(Map<String, dynamic> parsedJson) {
    return TeamNotice(
      parsedJson['id'],
      parsedJson['title'],
      parsedJson['body'],
      parsedJson['created_at'],
      parsedJson['updated_at'],
      User.fromJSON(parsedJson['author']),
    );
  }
}
