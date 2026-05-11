enum ChatMessageType {
  text,
  image,
  attachment,
  functionResult;

  String toJson() => name;

  static ChatMessageType fromJson(String json) {
    return ChatMessageType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => ChatMessageType.text,
    );
  }
}
