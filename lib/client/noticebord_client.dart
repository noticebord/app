import 'package:app/client/services/services.dart';

class NoticebordClient {
  static const String defaultBaseUrl = 'https://noticebord.space/api';

  String? token;
  String baseUrl;

  NoticebordClient({this.token, this.baseUrl = defaultBaseUrl});

  static Future<String> getToken(AuthenticateRequest request,
          {String baseUrl = defaultBaseUrl}) async =>
      await TokenService.getToken(baseUrl, request);

  NoticeService get notices => NoticeService(token, baseUrl);
  TeamService get teams => TeamService(token, baseUrl);
  TeamNoticeService get teamNotices => TeamNoticeService(token, baseUrl);
  TopicService get topics => TopicService(token, baseUrl);
  UserService get users => UserService(token, baseUrl);
}
