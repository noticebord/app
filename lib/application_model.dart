import 'package:app/client/noticebord_client.dart';
import 'package:flutter/foundation.dart';

class ApplicationModel with ChangeNotifier {
  NoticebordClient get client => NoticebordClient(token: token);

  String? token;

  void setToken(String? token)
  {
    this.token = token;
    notifyListeners();
  }
}