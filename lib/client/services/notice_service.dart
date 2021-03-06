import 'dart:convert';

import 'package:app/client/services/services.dart';
import 'package:http/http.dart' as http;

class NoticeService extends Service {
  NoticeService(String? token, String baseUrl) : super(token, baseUrl);

  Future<ListNotice> createNotice(SaveNoticeRequest request) async {
    final response = await http.post(Uri.parse('$baseUrl/notices'),
        headers: Service.defaultHeaders, body: jsonEncode(request));

    if (response.statusCode == 201) {
      final parsed = jsonDecode(response.body);
      return ListNotice.fromJSON(parsed);
    } else {
      throw Exception(
          'Failed to create notice - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future<PaginatedList<ListNotice>> fetchNotices({String? cursor}) async {
    final response = await http.get(Uri.parse('$baseUrl/notices?cursor=$cursor'),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return PaginatedList<ListNotice>.fromJSON(parsed);
    } else {
      throw Exception(
          'Failed to fetch notices - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future<Notice> fetchNotice(int noticeId) async {
    final response = await http.get(Uri.parse('$baseUrl/notices/$noticeId'),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      final notice = Notice.fromJSON(parsed);
      return notice;
    } else {
      throw Exception(
          'Failed to fetch notice - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future<ListNotice> updateNotice(int noticeId, SaveNoticeRequest request) async {
    final response = await http.put(Uri.parse('$baseUrl/notices/$noticeId'),
        headers: Service.defaultHeaders, body: jsonEncode(request));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return ListNotice.fromJSON(parsed);
    } else {
      throw Exception(
          'Failed to update notice - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future deleteNotice(int noticeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/notices/$noticeId'),
        headers: Service.defaultHeaders);

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(
          'Failed to delete notice - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
