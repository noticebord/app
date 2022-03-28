class Team {
  int id;
  int userId;
  String name;
  bool personalTeam;
  String createdAt;
  String updatedAt;

  Team(this.id, this.userId, this.name, this.personalTeam, this.createdAt,
      this.updatedAt);

  factory Team.fromJSON(Map<String, dynamic> parsedJson) {
    return Team(
      parsedJson['id'],
      parsedJson['user_id'],
      parsedJson['name'],
      parsedJson['personal_team'],
      parsedJson['created_at'],
      parsedJson['updated_at'],
    );
  }
}
