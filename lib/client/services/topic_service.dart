import 'dart:convert';

import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/notice.dart';
import 'package:app/client/models/topic.dart';
import 'package:http/http.dart' as http;

import 'service.dart';

class TopicService extends Service{
  TopicService(String token, String baseUrl): super(token, baseUrl);

  Future<List<Topic>> getTopics() async {
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

  Future<Topic> getTopic(int topicId) async {
    final response = await http.get(Uri.parse("$baseUrl/topics/$topicId"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return Topic.fromJSON(parsed);
    } else {
      throw Exception(
          "Failed to fetch topic - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<List<ListNotice>> getTopicNotices(int topicId) async {
    final response = await http.get(Uri.parse("$baseUrl/topics/$topicId/notices"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Notice>((item) => Notice.fromJSON(item)).toList();
    } else {
      throw Exception(
          "Failed to fetch notices - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }
}