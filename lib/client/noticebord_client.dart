import 'package:app/client/requests/authenticate_request.dart';

import 'services/notice_service.dart';
import 'services/team_notice_service.dart';
import 'services/team_service.dart';
import 'services/token_service.dart';
import 'services/topic_service.dart';
import 'services/user_service.dart';

class NoticebordClient {
  static const String defaultBaseUrl = "https://noticebord.space/api";

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
