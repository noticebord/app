abstract class Service {
  String token;
  String baseUrl;

  static Map<String, String> defaultHeaders = {
    "Accept": "application/json",
    "User-Agent": "app",
  };

  Service(this.token, this.baseUrl) {
    defaultHeaders["Authorization"] = "Bearer $token";
  }
}