import 'dart:convert';

import 'package:app/client/services/services.dart';
import 'package:http/http.dart' as http;

class TokenService {
  static Future<String> getToken(
    String baseUrl,
    AuthenticateRequest request,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tokens'),
      headers: Service.defaultHeaders,
      body: jsonEncode(request),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          'Failed to create token - ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
