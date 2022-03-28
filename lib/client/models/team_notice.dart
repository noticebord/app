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
      parsedJson['user_id'],
      parsedJson['name'],
      parsedJson['personal_team'],
      parsedJson['created_at'],
      User.fromJSON(parsedJson['updated_at']),
    );
  }
}
