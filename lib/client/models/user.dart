class User {
  int id;
  String name;
  String email;
  String createdAt;
  String profilePhotoUrl;

  User(this.id, this.name, this.email, this.createdAt, this.profilePhotoUrl);

  factory User.fromJSON(Map<String, dynamic> parsedJson) {
    return User(
      parsedJson['id'],
      parsedJson['name'],
      parsedJson['email'],
      parsedJson['created_at'],
      parsedJson['profile_photo_url'],
    );
  }
}
