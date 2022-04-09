import 'package:app/client/models/nested_topic.dart';
import 'package:app/client/models/user.dart';

class Notice {
  int id;
  String title;
  String body;
  String createdAt;
  String updatedAt;
  List<NestedTopic> topics;
  User? author;

  Notice(this.id, this.title, this.body, this.createdAt, this.updatedAt, this.topics,
      this.author);

  factory Notice.fromJSON(Map<String, dynamic> parsedJson) {
    return Notice(
      parsedJson['id'],
      parsedJson['title'],
      parsedJson['body'],
      parsedJson['created_at'],
      parsedJson['updated_at'],
      parsedJson["topics"].map<NestedTopic>((t) => NestedTopic.fromJSON(t)).toList(),
      parsedJson['author'] == null ? null : User.fromJSON(parsedJson['author']),
    );
  }
}
