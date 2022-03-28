class TokenService {
  static Future<String> getToken(
    String baseUrl,
    String email,
    String password,
    String deviceName,
  ) async =>
      await Future.delayed(const Duration(seconds: 1), () => "S3CR3TT0K3N");
}
