class SaveNoticeRequest {
  String title;
  String body;
  List<String> topics;
  bool anonymous;
  bool public;

  SaveNoticeRequest(
    this.title,
    this.body,
    this.topics,
    this.anonymous,
    this.public,
  );

  Map toJson() => {
        'title': title,
        'body': body,
        'topics': topics,
        'anonymous': anonymous,
        'public': public
      };
}
