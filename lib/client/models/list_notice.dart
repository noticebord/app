import 'package:app/client/models/models.dart';

class ListNotice {
  int id;
  String title;
  String createdAt;
  String updatedAt;
  List<NestedTopic> topics;
  User? author;

  ListNotice(this.id, this.title, this.createdAt, this.updatedAt, this.topics,
      this.author);

  factory ListNotice.fromJSON(Map<String, dynamic> parsedJson) {
    return ListNotice(
      parsedJson['id'],
      parsedJson['title'],
      parsedJson['created_at'],
      parsedJson['updated_at'],
      parsedJson['topics'].map<NestedTopic>((t) => NestedTopic.fromJSON(t)).toList(),
      parsedJson['author'] == null ? null : User.fromJSON(parsedJson['author']),
    );
  }
}
