import 'dart:convert';

import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/requests/save_notice_request.dart';
import 'package:http/http.dart' as http;

import 'service.dart';

class NoticeService extends Service {
  NoticeService(String? token, String baseUrl) : super(token, baseUrl);

  Future<Notice> createNotice(SaveNoticeRequest request) async {
    final response = await http.post(Uri.parse("$baseUrl/notices"),
        headers: Service.defaultHeaders, body: request);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return Notice.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to create notice - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<PaginatedList<ListNotice>> fetchNotices({String? cursor}) async {
    final response = await http.get(Uri.parse("$baseUrl/notices?cursor=$cursor"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return PaginatedList<ListNotice>.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to fetch notices - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<Notice> fetchNotice(int noticeId) async {
    final response = await http.get(Uri.parse("$baseUrl/notices/$noticeId"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return Notice.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to fetch notice - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<Notice> updateNotice(int noticeId, SaveNoticeRequest request) async {
    final response = await http.put(Uri.parse("$baseUrl/notices/$noticeId"),
        headers: Service.defaultHeaders, body: request);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return Notice.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to update notice - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future deleteNotice(int noticeId) async {
    final response = await http.delete(Uri.parse("$baseUrl/notices/$noticeId"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(
          "Failed to delete notice - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }
}
