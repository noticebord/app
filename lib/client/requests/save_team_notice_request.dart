class SaveTeamNoticeRequest {
  String title;
  String body;

  SaveTeamNoticeRequest({this.title = '', this.body = ''});

  Map toJson() => {'title': title, 'body': body};
}
