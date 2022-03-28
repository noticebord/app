import 'package:app/client/models/topic.dart';
import 'package:app/client/models/user.dart';

class ListNotice {
  int id;
  String title;
  String createdAt;
  String updatedAt;
  List<Topic> topics;
  User author;

  ListNotice(this.id, this.title, this.createdAt, this.updatedAt, this.topics,
      this.author);

  factory ListNotice.fromJSON(Map<String, dynamic> parsedJson) {
    return ListNotice(
      parsedJson['id'],
      parsedJson['title'],
      parsedJson['created_at'],
      parsedJson['updated_at'],
      parsedJson["topics"].map((t) => Topic.fromJSON(t)),
      User.fromJSON(parsedJson['updated_at']),
    );
  }
}
