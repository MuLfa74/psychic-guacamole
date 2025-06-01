import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required String role,
    required String content,
  }) : super(role: role, content: content);

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(role: entity.role, content: entity.content);
  }

  ChatMessage toEntity() {
    return ChatMessage(role: role, content: content);
  }
}
