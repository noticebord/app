import 'package:app/client/noticebord_client.dart';
import 'package:flutter/foundation.dart';

class ApplicationModel with ChangeNotifier {
  NoticebordClient get client => NoticebordClient(
        token: token,
        baseUrl: "https://noticebord.herokuapp.com/api",
      );

  int page = 0;
  String? token;

  void setPage(int page) {
    this.page = page;
    notifyListeners();
  }

  void setToken(String? token) {
    this.token = token;
    notifyListeners();
  }
}
