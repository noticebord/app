class NestedTopic {
  int id;
  String name;

  NestedTopic(this.id, this.name);

  factory NestedTopic.fromJSON(Map<String, dynamic> parsedJson) {
    return NestedTopic(
      parsedJson['id'],
      parsedJson['name'],
    );
  }
}
