import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/list_team_notice.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:flutter/foundation.dart';

class ApplicationModel with ChangeNotifier {
  final url = "https://noticebord.herokuapp.com";

  NoticebordClient get client => NoticebordClient(token: token, baseUrl: "$url/api");

  int page = 0;
  String? token;
  int? user;
  List<ListNotice> notices = [];
  List<ListNotice> topicNotices = [];
  List<ListTeamNotice> teamNotices = [];

  // Page

  void setPage(int page) {
    this.page = page;
    notifyListeners();
  }

  // Auth

  void setAuth(String token, int user) {
    this.token = token;
    this.user = user;
    notifyListeners();
  }

  void removeAuth() {
    token = null;
    user = null;
    notifyListeners();
  }

  // Notices & Topic Notices

  void addNotices(List<ListNotice> notices) {
    this.notices.addAll(notices);
    notifyListeners();
  }

  void setNotices(List<ListNotice> notices) {
    this.notices = notices;
    notifyListeners();
  }

  void addTopicNotices(List<ListNotice> notices) {
    topicNotices.addAll(notices);
    notifyListeners();
  }

  void setTopicNotices(List<ListNotice> notices) {
    topicNotices = notices;
    notifyListeners();
  }

  void updateNotice(int id, ListNotice notice) {
    bool predicate(ListNotice notice) => notice.id == id;

    // Update the notices view
    final noticesIndex = notices.indexWhere(predicate);
    if (noticesIndex >= 0) {
      notices[noticesIndex] = notice;
    }

    // Also update the topic notices view
    final topicNoticesIndex = topicNotices.indexWhere(predicate);
    if (topicNoticesIndex >= 0) {
      topicNotices[topicNoticesIndex] = notice;
    }

    notifyListeners();
  }

  void removeNotice(int id) {
    notices.removeWhere((notice) => notice.id == id);
    topicNotices.removeWhere((notice) => notice.id == id);
    notifyListeners();
  }

  // Team Notices

  void addTeamNotices(List<ListTeamNotice> notices) {
    teamNotices.addAll(notices);
    notifyListeners();
  }

  void setTeamNotices(List<ListTeamNotice> notices) {
    teamNotices = notices;
    notifyListeners();
  }

  void updateTeamNotice(int id, ListTeamNotice notice) {
    final index = teamNotices.indexWhere((notice) => notice.id == id);
    if (index >= 0) {
      teamNotices[index] = notice;
    }

    notifyListeners();
  }

  void removeTeamNotice(int id) {
    teamNotices.removeWhere((notice) => notice.id == id);
    notifyListeners();
  }
}
