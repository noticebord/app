import 'dart:convert';

import 'package:app/client/models/team.dart';
import 'package:http/http.dart' as http;

import 'service.dart';

class TeamService extends Service{
  TeamService(String token, String baseUrl): super(token, baseUrl);

  Future<List<Team>> getTeams() async {
    final response = await http.get(Uri.parse("$baseUrl/teams"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Team>((item) => Team.fromJSON(item)).toList();
    } else {
      throw Exception(
          "Failed to fetch teams - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<Team> getTeam(int teamId) async {
    final response = await http.get(Uri.parse("$baseUrl/teams/$teamId"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return Team.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to fetch team - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }
}