import 'package:app/client/models/list_notice.dart';
import 'package:app/client/noticebord_client.dart';
import 'package:flutter/foundation.dart';

class ApplicationModel with ChangeNotifier {
  final url = "https://noticebord.herokuapp.com";

  NoticebordClient get client => NoticebordClient(token: token, baseUrl: "$url/api");

  int page = 0;
  String? token;
  int? user;
  List<ListNotice> notices = [];

  void setPage(int page) {
    this.page = page;
    notifyListeners();
  }

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

  void addNotices(List<ListNotice> notices) {
    this.notices.addAll(notices);
    notifyListeners();
  }

  void setNotices(List<ListNotice> notices) {
    this.notices = notices;
    notifyListeners();
  }

  void updateNotice(int id, ListNotice notice) {
    final index = notices.indexWhere((notice) => notice.id == id);
    notices[index] = notice;
    notifyListeners();
  }

  void removeNotice(int id) {
    notices.removeWhere((notice) => notice.id == id);
    notifyListeners();
  }
}
