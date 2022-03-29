import 'dart:convert';

import 'package:app/client/models/list_notice.dart';
import 'package:app/client/models/notice.dart';
import 'package:app/client/models/user.dart';
import 'package:http/http.dart' as http;

import 'service.dart';

class UserService extends Service{
  UserService(String? token, String baseUrl): super(token, baseUrl);

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<User>((item) => User.fromJSON(item)).toList();
    } else {
      throw Exception(
          "Failed to fetch users - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<User> getUser(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$userId"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<User>((item) => User.fromJSON(item)).toList();
    } else {
      throw Exception(
          "Failed to fetch user - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<List<ListNotice>> getUserNotices(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$userId/notices"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Notice>((item) => Notice.fromJSON(item)).toList();
    } else {
      throw Exception(
          "Failed to fetch user notices - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<List<ListNotice>> getUserNotes(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$userId/notes"),
        headers: Service.defaultHeaders);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Notice>((item) => Notice.fromJSON(item)).toList();
    } else {
      throw Exception(
          "Failed to fetch user notes - ${response.statusCode}: ${response.reasonPhrase}");
    }
  }
}