class SaveNoticeRequest {
  String title;
  String body;
  List<String> topics;
  bool anonymous;
  bool public;

  SaveNoticeRequest({
    this.title = '',
    this.body = '',
    this.topics = const [],
    this.anonymous = false,
    this.public = false,
  });

  Map toJson() => {
        'title': title,
        'body': body,
        'topics': topics,
        'anonymous': anonymous,
        'public': public
      };
}
