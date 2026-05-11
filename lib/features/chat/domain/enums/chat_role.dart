enum ChatRole {
  user,
  assistant,
  system;

  String toJson() => name;

  static ChatRole fromJson(String json) {
    return ChatRole.values.firstWhere(
      (e) => e.name == json,
      orElse: () => ChatRole.user,
    );
  }
}
