class Topic {
  int id;
  String name;
  int count;

  Topic(this.id, this.name, this.count);

  factory Topic.fromJSON(Map<String, dynamic> parsedJson) {
    return Topic(
      parsedJson['id'],
      parsedJson['name'],
      parsedJson['count'],
    );
  }
}
