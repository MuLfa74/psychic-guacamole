import '../enums/chat_message_type.dart';
import '../enums/chat_role.dart';

class ChatMessage {
  final ChatRole role;
  final String content;
  final ChatMessageType type;
  final String? attachmentId;
  final String? imageId;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.role,
    required this.content,
    this.type = ChatMessageType.text,
    this.attachmentId,
    this.imageId,
    this.metadata,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: ChatRole.fromJson(json['role'] as String? ?? 'user'),
      content: json['content'] as String,
      type: ChatMessageType.fromJson(json['type'] as String? ?? 'text'),
      attachmentId: json['attachmentId'] as String?,
      imageId: json['imageId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'content': content,
      'type': type.toJson(),
      if (attachmentId != null) 'attachmentId': attachmentId,
      if (imageId != null) 'imageId': imageId,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
