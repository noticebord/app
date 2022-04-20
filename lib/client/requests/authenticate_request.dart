class AuthenticateRequest {
  String email;
  String password;
  String deviceName;

  AuthenticateRequest(this.email, this.password, this.deviceName);

  Map toJson() => {
        'email': email,
        'password': password,
        'device_name': deviceName,
      };
}
