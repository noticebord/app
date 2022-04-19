import 'dart:convert';

import 'package:app/client/models/list_team_notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/models/team_notice.dart';
import 'package:app/client/requests/save_team_notice_request.dart';
import 'package:http/http.dart' as http;

import 'service.dart';

class TeamNoticeService extends Service {
  TeamNoticeService(String? token, String baseUrl) : super(token, baseUrl);

  Future<TeamNotice> createTeamNotice(
      int teamId, SaveTeamNoticeRequest request) async {
    final response = await http.post(
        Uri.parse("$baseUrl/teams/$teamId/notices"),
        headers: Service.defaultHeaders,
        body: jsonEncode(request));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return TeamNotice.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to create team notice - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<PaginatedList<ListTeamNotice>> fetchTeamNotices(int teamId, {String? cursor}) async {
    final response = await http.get(Uri.parse("$baseUrl/teams/$teamId/notices?cursor=$cursor"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return PaginatedList<ListTeamNotice>.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to fetch team notices - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<TeamNotice> fetchTeamNotice(int teamId, int noticeId) async {
    final response = await http.get(
        Uri.parse("$baseUrl/teams/$teamId/notices/$noticeId"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return TeamNotice.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to fetch team notice - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<ListTeamNotice> updateTeamNotice(
      int teamId, int noticeId, SaveTeamNoticeRequest request) async {
    final response = await http.put(
        Uri.parse("$baseUrl/teams/$teamId/notices/$noticeId"),
        headers: Service.defaultHeaders,
        body: jsonEncode(request));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return ListTeamNotice.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to update team notice - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future deleteTeamNotice(int teamId, int noticeId) async {
    final response = await http.delete(
        Uri.parse("$baseUrl/teams/$teamId/notices/$noticeId"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(
          "Failed to delete team notice - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }
}
