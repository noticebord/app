import 'dart:convert';

import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/paginated_list.dart';
import 'package:app/client/models/topic.dart';
import 'package:http/http.dart' as http;

import 'service.dart';

class TopicService extends Service {
  TopicService(String? token, String baseUrl) : super(token, baseUrl);

  Future<List<Topic>> fetchTopics() async {
    final response = await http.get(Uri.parse("$baseUrl/topics"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Topic>(Topic.fromJSON).toList();
    } else {
      throw Exception(
          "Failed to fetch topics - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<Topic> fetchTopic(int topicId) async {
    final response = await http.get(Uri.parse("$baseUrl/topics/$topicId"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return Topic.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to fetch topic - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<PaginatedList<ListNotice>> fetchTopicNotices(
    int topicId, {
    String? cursor,
  }) async {
    final response = await http.get(
        Uri.parse("$baseUrl/topics/$topicId/notices?cursor=$cursor"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return PaginatedList<ListNotice>.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to fetch notices - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }
}
